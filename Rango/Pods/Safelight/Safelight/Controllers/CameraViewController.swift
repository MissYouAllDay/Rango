import UIKit
import AssetsLibrary
import JPSVolumeButtonHandler


enum ImageSource {
    case camera
    case album
}

class CameraViewController: UIViewController {

    fileprivate var camera: LLSimpleCamera!
    fileprivate var errorLabel: UILabel!
    fileprivate var topBar: UIView!
    fileprivate var switchButton: UIButton!
    fileprivate var flashButton: UIButton!
    fileprivate var guideLine: UIImageView!
    fileprivate var tipsBar: UIView!
    fileprivate var tipsLabel: UILabel!
    fileprivate var bottomBar: UIView!
    fileprivate var snapButton: UIButton!
    fileprivate var albumButton: UIButton!
    fileprivate var backButton: UIButton!
    fileprivate var tipsTimer: Timer!

    //传递delegate
    var delegate: SafelightDelegate?

    fileprivate static let library: ALAssetsLibrary = ALAssetsLibrary()
    fileprivate static var volumeButtonHandler: JPSVolumeButtonHandler!

    //是否在快门按下处理中
    fileprivate var notSnaping = true
    fileprivate var notSnapingAlbumIgnore = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
        let screenSize = UIScreen.main.bounds.size

        // 除非规格明确指定需要前置摄像头，否则默认为后置摄像头
        var position = CameraPositionBack
        if let facing = MSAfx.spec?.preferredCameraFacing, facing == .Front {
            position = CameraPositionFront
        }

        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh,
                                     position: position,
                                     videoEnabled: false)
        self.camera.fixOrientationAfterCapture = false
        self.camera.useDeviceOrientation = true
        self.camera.onDeviceChange = { [weak self] camera, device in
            guard let strongSelf = self else { return }
            strongSelf.flashButton.isHidden = !(camera?.isFlashAvailable())!
        }
        self.camera.onError = { [weak self] camera, error in
            guard let strongSelf = self else { return }

            if error?._domain != LLSimpleCameraErrorDomain {
                return
            }

            if let label = strongSelf.errorLabel {
                label.removeFromSuperview()
            }
            let label = UILabel(frame: CGRect.zero)
            label.text = "提示:请在系统设置中打开相机权限"
            label.numberOfLines = 2
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.backgroundColor = UIColor.clear
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor.white
            label.textAlignment = NSTextAlignment.center
            label.sizeToFit()
            label.center = CGPoint(
                x: screenSize.width / 2.0, y: screenSize.height / 2.0
            )
            strongSelf.view.addSubview(label)
            strongSelf.errorLabel = label
        }
    }

    func imageWithName(_ name: String) -> UIImage {
        let bundle = Bundle(for: CameraViewController.self)
        return UIImage(contentsOfFile: bundle.path(forResource: name, ofType: "png")!)!
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.detailMessage()
    }

    func detailMessage() {
        if MSAfx.isChecked {
            showCamera()
        } else {
            //校验
            MSAfx.loadingView.show(self, with: "校验中")
            Protocol.sharedInstance.getSpecInfo(MSAfx.specKey) { [weak self] spec, error in

                guard let strongSelf = self else { return }

                MSAfx.loadingView.hide(nil)

                if let spec = spec {
                    var invalidBackdrop: Bool
                    if MSAfx.beginColor == nil && MSAfx.endColor == nil {
                        invalidBackdrop = false
                    } else {
                        let beginColor = uiColorFromInt(MSAfx.beginColor!, alpha: 1.0)
                        let endColor = uiColorFromInt(MSAfx.endColor!, alpha: 1.0)
                        invalidBackdrop = spec.backdrops.filter{ $0.beginColor == beginColor && $0.endColor == endColor }.isEmpty
                    }

                    if invalidBackdrop {
                        let error = SafelightError.invalidParameter("指定的背景色与规格不符").error()
                        strongSelf.delegate?.safelightFinished(error: error)
                        strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                    } else {
                        MSAfx.spec = spec

                        // 添加控件
                        strongSelf.addControls()

                        // 调整控件位置
                        strongSelf.layoutControls()

                        // 横屏标记
                        strongSelf.isLandscape = spec.isLandscape()

                        MSAfx.isChecked = true
                        strongSelf.showCamera()
                    }
                } else {
                    strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                    strongSelf.delegate?.safelightFinished(error: error)
                }
            }
        }
    }

    func showCamera() {
        NavigationController.setPortrait(!MSAfx.spec.isLandscape(), controller: self)

        //打开计时器
        self.tipsTimer = Timer.scheduledTimer(
            timeInterval: 2.0,
            target: self,
            selector: #selector(CameraViewController.refreshTips),
            userInfo: nil,
            repeats: true
        )

        //替换对焦框
        addCustomFocusBox()
        //自拍杆
        if true == notSnapingAlbumIgnore {
            notSnapingAlbumIgnore = false
        } else {
            notSnaping = true
        }
        CameraViewController.volumeButtonHandler = JPSVolumeButtonHandler(up: {
            [weak self] in
            if let strongSelf = self {
                strongSelf.snapButtonPressed(nil)
            }
            }, downBlock: {
                [weak self] in
                if let strongSelf = self {
                    strongSelf.snapButtonPressed(nil)
                }
            })

        // start the camera
        self.camera.start()
    }

    override  func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //隐藏状态栏
        UIApplication.shared.setStatusBarHidden(
            true, with: UIStatusBarAnimation.none
        )
        if self.camera.view.frame.width != self.view.frame.width
            || self.camera.view.frame.height != self.view.frame.height {
                layoutControls()
        }

        setControlsHidden(false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //横屏下再拍一张会出现位置错误
        if isLandscape {
            layoutControls()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // stop the camera
        self.camera.stop()

        //自拍杆
        notSnaping = false
        CameraViewController.volumeButtonHandler = nil
    }

    //析构函数
    deinit {
        MSAfx.loadingView.hide(nil)
    }

    //MARK: 切换摄像头
    func switchButtonPressed(_ button: UIButton) {
        self.camera.togglePosition()
    }

    //MARK: 切换闪光灯
    func flashButtonPressed(_ button: UIButton) {
        if self.camera.flash == CameraFlashOff {
            if self.camera.updateFlashMode(CameraFlashOn) {
                self.flashButton.setImage(
                    imageWithName("button_flashlight@2x"),
                    for: UIControlState()
                )
            }
        } else {
            if self.camera.updateFlashMode(CameraFlashOff) {
                self.flashButton.setImage(
                    imageWithName("button_flashlight_forbid@2x"),
                    for: UIControlState()
                )
            }
        }
    }

    //MARK: 拍摄
    func snapButtonPressed(_ button: UIButton!) {
        if notSnaping {
            notSnaping = false
            self.camera.capture({ [weak self] camera, image, metadata, error in
                guard let strongSelf = self else { return }

                if let image = image {
                    camera?.stop()
                    strongSelf.checkPicture(image, src: .camera)
                } else {
                    let message = "出现异常，拍摄失败"
                    let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)

                    let ok = UIAlertAction(title: "确定", style: .default) { [weak self] action in
                        guard let strongSelf = self else { return }
                        strongSelf.notSnaping = true
                    }
                    alert.addAction(ok)

                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }, exactSeenImage: true)
        }
    }

    //MARK: 相册
    func albumButtonPressed(_ button: UIButton!) {
        if notSnaping {
            notSnaping = false

            setControlsHidden()

            let pickerImage = UIImagePickerController()
            if !UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.photoLibrary) {
                    pickerImage.sourceType = UIImagePickerControllerSourceType
                        .photoLibrary
                    pickerImage.mediaTypes = UIImagePickerController
                        .availableMediaTypes(for: pickerImage.sourceType)!
            }
            //状态栏透明去除
            pickerImage.navigationBar.isTranslucent = false

            pickerImage.delegate = self
            pickerImage.allowsEditing = false
            self.present(pickerImage, animated: true) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.notSnapingAlbumIgnore = true
            }
        }
    }

    //MARK: 返回
    func backButtonPressed(_ button: UIButton!) {
        setControlsHidden()
        NavigationController.setPortrait(true, controller: self)
        self.navigationController?.dismiss(animated: true, completion: nil)
        self.delegate?.safelightFinished(error: SafelightError.userCancelled.error())
    }

    func checkPicture(_ img: UIImage, src: ImageSource) {
        MSAfx.loadingView.show(self, with: "正在评估您的拍摄环境")

        let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
        queue.async { [weak self] in
            // 获取人脸数及人脸框
            var num = 0
            if let JYManager = MSJYManager.sharedInstance() as? MSJYManager {
                num = JYManager.pretreat(
                    img,
                    photoParm: (MSAfx.spec)!
                )
            }

            DispatchQueue.main.async {
                //这里返回主线程，写需要主线程执行的代码
                switch num {
                case 0:
                    MSAfx.loadingView.hide("没有检测到人脸哦~")
                    self?.camera.start()
                    self?.notSnaping = true

                case MSAfx.spec.numFaces:
                    var area = CGRect.zero
                    if let tarArea = (MSAfx.contextImage.param["area"] as?
                        NSValue)?.cgRectValue {
                            area = tarArea
                    }
                    let sizeTarget = CGSize(
                        width: MSAfx.spec.width,
                        height: MSAfx.spec.height
                    )
                    if area.size.width > 1800 || area.size.height > 1800 {
                        MSAfx.loadingView.hide("人脸太大啦，离摄像头远一点点")
                        self?.camera.start()
                        self?.notSnaping = true
                    } else {
                        MSAfx.loadingView.hide(nil)
                        if area.size.width < sizeTarget.width
                            || area.size.height < sizeTarget.height {

                            let message = "检测到照片中人脸分辨率太低，可能会导致生成的证件照模糊，建议重新拍摄"
                            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

                            let next = UIAlertAction(title: "下一步", style: .default) { [weak self] action in
                                self?.setFinalImage()
                            }
                            alert.addAction(next)

                            let again = UIAlertAction(title: "重新拍摄", style: .cancel) { [weak self] action in
                                self?.camera.start()
                                self?.notSnaping = true
                            }
                            alert.addAction(again)

                            self?.present(alert, animated: true, completion: nil)
                        } else {
                            self?.setFinalImage()
                        }
                    }

                default:
                    var tip = "人脸太多了啦"
                    if MSAfx.spec.isMarriage() {
                        if num > MSAfx.spec.numFaces {
                            tip = "结婚是两个人的事哦~"
                        } else {
                            tip = "结婚照要两个人一起拍哦~"
                        }
                    }
                    MSAfx.loadingView.hide(tip)
                    self?.camera.start()
                    self?.notSnaping = true
                }
            }
        }
    }

    //保存图片
    static func albumSaveImage(_ controller: UIViewController, img: UIImage,
                               final: @escaping (_ error: NSError?) -> Void,
                               fail: @escaping () -> Void) {
        let name = "智能证件照"
        CameraViewController.library.save(img, toAlbum: name) { [weak controller] error in
            guard let controller = controller else { return }

            if let _ = error {
                let message = "没有保存到相册的权限，请在系统隐私中打开"
                let alert = UIAlertController(title: "缺少权限", message: message, preferredStyle: .alert)

                let ok = UIAlertAction(title: "确定", style: .default) { action in
                    fail()
                }
                alert.addAction(ok)

                controller.present(alert, animated: true, completion: nil)
            }
            final(error as NSError?)
        }
    }

    func setFinalImage() {
        MSAfx.modelImage = MUGImageVM(cont: MSAfx.contextImage)
        NavigationController.setPortrait(true, controller: self)
        let scoreVC = ScoreViewController()
        scoreVC.delegate = delegate

        self.navigationController?.pushViewController(scoreVC, animated: true)

        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
    }

    // MARK: 隐藏状态栏
    override  var prefersStatusBarHidden : Bool {
        return true
    }

    // MARK: 方向
    override  var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }

    // MARK: 添加控件
    func addControls() {
        let screenSize = UIScreen.main.bounds.size

        //相机画面
        self.camera.attach(to: self,
            withFrame: CGRect(origin: CGPoint.zero, size: screenSize)
        )
        //横屏处理
        self.camera.isTapRetroflexion = isLandscape
        if isLandscape {
            //重定方向
            fanZhuan(self.camera.view, dushu: -90)
        }

        //顶部条状物
        self.topBar = UIView()
        self.topBar.backgroundColor = UIColor(rValue: 0, gValue: 0, bValue: 0, aValue: 0.3)
        self.view.addSubview(self.topBar)

        //闪光灯
        self.flashButton = UIButton(type: UIButtonType.system)
        self.flashButton.tintColor = UIColor.white
        self.flashButton.setImage(imageWithName("button_flashlight_forbid@2x"),
            for: UIControlState())
        self.flashButton.addTarget(self, action: #selector(CameraViewController.flashButtonPressed(_:)),
            for: UIControlEvents.touchUpInside)
        self.topBar.addSubview(self.flashButton)

        //切换摄像头
        self.switchButton = UIButton(type: UIButtonType.system)
        self.switchButton.tintColor = UIColor.white
        self.switchButton.setImage(imageWithName("button_switch@2x"),
            for: UIControlState())
        self.switchButton.addTarget(self, action: #selector(CameraViewController.switchButtonPressed(_:)),
            for: UIControlEvents.touchUpInside)
        self.topBar.addSubview(self.switchButton)

        //辅助线:normal-3/4,marry-4/3
        self.guideLine = UIImageView()
        self.guideLine.image = (MSAfx.spec.isMarriage() ? imageWithName("辅助线@2x") : imageWithName("辅助线4比3@2x"))
        self.view.addSubview(self.guideLine)
        //tips条状物(容器+文字)
        self.tipsBar = UIView()
        self.tipsBar.backgroundColor = UIColor(rValue: 224, gValue: 224, bValue: 224, aValue: 0.6)
        self.view.addSubview(self.tipsBar)
        self.tipsLabel = UILabel()
        self.tipsLabel.text = ""
        self.tipsLabel.textColor = UIColor.white
        self.tipsLabel.numberOfLines = 0
        self.tipsLabel.font = UIFont.systemFont(ofSize: 12)
        self.tipsLabel.backgroundColor = UIColor.clear
        self.tipsBar.addSubview(self.tipsLabel)

        //底部条状物
        self.bottomBar = UIView()
        self.bottomBar.backgroundColor = UIColor(rValue: 33, gValue: 33, bValue: 33, aValue: 1)
        self.view.addSubview(self.bottomBar)

        //拍摄按钮
        self.snapButton = UIButton()
        self.snapButton.setImage(imageWithName("快门按钮@2x"), for: UIControlState())
        self.snapButton.contentMode = UIViewContentMode.scaleToFill
        self.snapButton.addTarget(self, action: #selector(CameraViewController.snapButtonPressed(_:)),
            for: UIControlEvents.touchUpInside)
        self.bottomBar.addSubview(self.snapButton)

        //相册按钮
        self.albumButton = UIButton()
        self.albumButton.setImage(imageWithName("button_photo@2x"), for: UIControlState())
        self.albumButton.contentMode = UIViewContentMode.scaleToFill
        self.albumButton.addTarget(self, action: #selector(CameraViewController.albumButtonPressed(_:)),
            for: UIControlEvents.touchUpInside)
        self.bottomBar.addSubview(self.albumButton)

        //返回按钮
        self.backButton = UIButton()
        self.backButton.setImage(imageWithName("button_back@2x"), for: UIControlState())
        self.backButton.contentMode = UIViewContentMode.scaleToFill
        self.backButton.addTarget(self, action: #selector(CameraViewController.backButtonPressed(_:)),
            for: UIControlEvents.touchUpInside)
        self.bottomBar.addSubview(self.backButton)
    }

    func fanZhuan(_ view: UIView, dushu: Int) {
        let trans = CGAffineTransform(
            rotationAngle: CGFloat(Double(dushu) / 180.0 * M_PI)
        )
        view.transform = CGAffineTransform.identity
        view.transform = trans
    }

    // MARK: 横屏
    fileprivate var isLandscape = false

    // MARK: 调整控件位置
    func layoutControls() {
        let screenSize = UIScreen.main.bounds.size

        self.camera.view.frame = CGRect(
            x: 0.0, y: 0.0, width: screenSize.width, height: screenSize.height
        )

        //是否允切换摄像头
        self.switchButton.isHidden = MSAfx.spec.preferredCameraFacing != nil

        if !isLandscape {//竖屏
            //
            self.topBar.frame = CGRect(
                x: 0, y: 0, width: screenSize.width, height: 50.0
            )
            //
            let flashButtonSize = CGSize(width: 50.0, height: 50.0)
            self.flashButton.frame = CGRect(
                origin: CGPoint(x: screenSize.width - flashButtonSize.width, y: 0),
                size: flashButtonSize
            )
            //
            self.switchButton.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
            //
            let guideLineSize = CGSize(
                width: screenSize.width,
                height: (MSAfx.spec.isMarriage() ? (screenSize.width / 4.0 * 3.0)
                    : (screenSize.width / 3.0 * 4.0))
            )
            self.guideLine.frame = CGRect(origin: CGPoint.zero, size: guideLineSize)
            //
            refreshTips()
            //
            self.bottomBar.frame = CGRect(
                x: 0, y: screenSize.height - 69,
                width: screenSize.width, height: 69
            )
            //必须在 bottomBar 位置确定后
            self.guideLine.center = CGPoint(
                x: self.view.center.x,
                y: (self.bottomBar.frame.minY + self.topBar.frame.maxY) / 2.0
            )
            //
            let snapButtonSize = CGSize(width: 56, height: 56)
            self.snapButton.frame = CGRect(
                origin: CGPoint(
                    x: (screenSize.width - snapButtonSize.width) / 2.0,
                    y: (self.bottomBar.frame.height - snapButtonSize.height) / 2.0
                ),
                size: snapButtonSize
            )
            //
            let albumButtonSize = CGSize(width: 60.0, height: 60.0)
            self.albumButton.frame = CGRect(
                origin: CGPoint(
                    x: 10,
                    y: (self.bottomBar.frame.height - albumButtonSize.height) / 2.0),
                size: albumButtonSize
            )
            //
            let backButtonSize = CGSize(width: 60.0, height: 60.0)
            self.backButton.frame = CGRect(
                origin: CGPoint(
                    x: self.bottomBar.frame.maxX - 10.0 - backButtonSize.width,
                    y: (self.bottomBar.frame.height - albumButtonSize.height) / 2.0
                ),
                size: backButtonSize
            )
        } else {//横屏
            //
            self.topBar.frame = CGRect(
                x: 0, y: 0, width: 44, height: screenSize.height
            )
            //
            let flashButtonSize = CGSize(width: 44, height: 44)
            self.flashButton.frame = CGRect(
                origin: CGPoint(x: 0, y: 10),
                size: flashButtonSize
            )
            //
            let switchButtonSize = CGSize(width: 44, height: 44)
            self.switchButton.frame = CGRect(
                origin: CGPoint(
                    x: 0,
                    y: topBar.frame.height - 10 - switchButtonSize.height
                ),
                size: switchButtonSize
            )
            //
            let guideLineSize = CGSize(
                width: (MSAfx.spec.isMarriage())
                    ? ((screenSize.height - 74) / 3.0 * 4.0)
                    : ((screenSize.height - 74) / 4.0 * 3.0),
                height: screenSize.height - 74
            )
            self.guideLine.frame = CGRect(origin: CGPoint.zero, size: guideLineSize)
            //
            self.bottomBar.frame = CGRect(
                x: screenSize.width - 69, y: 0,
                width: 69, height: screenSize.height
            )
            //必须在 bottomBar 位置确定后
            refreshTips()
            self.guideLine.center = CGPoint(
                x: (bottomBar.frame.minX + topBar.frame.maxX) / 2,
                y: screenSize.height / 2
            )
            //
            let snapButtonSize = CGSize(width: 56, height: 56)
            self.snapButton.frame = CGRect(
                origin: CGPoint(
                    x: (bottomBar.frame.width - snapButtonSize.width) / 2.0,
                    y: (bottomBar.frame.height - snapButtonSize.height) / 2.0
                ),
                size: snapButtonSize
            )
            //
            let albumButtonSize = CGSize(width: 60.0, height: 60.0)
            self.albumButton.frame = CGRect(
                origin: CGPoint(
                    x: (bottomBar.frame.width - albumButtonSize.width) / 2.0,
                    y: self.bottomBar.frame.height - 10 - albumButtonSize.height
                ),
                size: albumButtonSize
            )
            //
            let backButtonSize = CGSize(width: 60.0, height: 60.0)
            self.backButton.frame = CGRect(
                origin: CGPoint(
                    x: (bottomBar.frame.width - backButtonSize.width) / 2.0,
                    y: 10
                ),
                size: backButtonSize
            )
        }
    }

    // MARK: 顶部提示刷新
    fileprivate var tipIndex = 0
    func refreshTips() {
        let tar = (
            (self.camera.position != CameraPositionBack) ? [
                "后置摄像头拍摄的证件照更规范哦！",
                "建议使用后置摄像头拍摄！",
                ] : [
                    "请他人协助拍摄！",
                    "请选择光照充足的地方拍摄哦！",
                    "建议在白色墙壁前拍照",
                    "避免服装颜色与背景相同！",
                    "注意摆正头部哦！",
            ]
        )
        let screenSize = UIScreen.main.bounds.size
        tipIndex += 1
        self.tipsLabel.text = tar[(tipIndex) % tar.count]
        self.tipsLabel.font = UIFont.systemFont(ofSize: 12)
        self.tipsLabel.frame = CGRect(origin: CGPoint.zero, size: screenSize)
        self.tipsLabel.sizeToFit()
        let textSize = self.tipsLabel.frame.size
        self.tipsLabel.frame = CGRect(origin: CGPoint(x: 10, y: 6), size: textSize)

        if !isLandscape {//竖屏
            let tipsBarSize = CGSize(width: textSize.width + 20, height: textSize.height + 12)
            self.tipsBar.frame = CGRect(
                origin: CGPoint(
                    x: self.topBar.center.x - tipsBarSize.width / 2,
                    y: self.topBar.frame.maxY
                ),
                size: tipsBarSize
            )
        } else {//横屏
            let tipsBarSize = CGSize(width: textSize.width + 20, height: textSize.height + 12)
            self.tipsBar.frame = CGRect(
                origin: CGPoint(
                    x: (bottomBar.frame.minX + topBar.frame.maxX
                        - tipsBarSize.width) / 2,
                    y: 15),
                size: tipsBarSize
            )
        }
        self.tipsBar.layer.cornerRadius = self.tipsBar.frame.height / 2
    }

    // MARK: 替换对焦框
    func addCustomFocusBox() {
        let focusBox = CALayer()
        focusBox.bounds = CGRect(
            x: 0.0, y: 0.0, width: 58.0, height: 58.0
        )
        focusBox.opacity = 0.0
        focusBox.contents = imageWithName("focus@2x").cgImage
        self.view.layer.addSublayer(focusBox)

        let focusBoxAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        focusBoxAnimation.duration = 2
        focusBoxAnimation.autoreverses = false
        focusBoxAnimation.repeatCount = 0.0
        focusBoxAnimation.fromValue = NSNumber(value: 1.0 as Float)
        focusBoxAnimation.toValue = NSNumber(value: 0.0 as Float)

        self.camera.alterFocusBox(focusBox, animation: focusBoxAnimation)
    }

    // MARK: 显示和隐藏
    func setControlsHidden(_ hidden: Bool = true) {
        if isLandscape {
            self.camera?.view?.isHidden = hidden
            errorLabel?.isHidden = hidden
            topBar?.isHidden = hidden
            switchButton?.isHidden = hidden
            flashButton?.isHidden = hidden
            guideLine?.isHidden = hidden
            tipsBar?.isHidden = hidden
            tipsLabel?.isHidden = hidden
            bottomBar?.isHidden = hidden
            snapButton?.isHidden = hidden
            albumButton?.isHidden = hidden
            backButton?.isHidden = hidden
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CameraViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: false) { [weak self] in
            guard let strongSelf = self else { return }
            let img = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
            strongSelf.checkPicture(img, src: .album)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
        notSnaping = true
    }
}


// MARK: - UINavigationControllerDelegate
extension CameraViewController: UINavigationControllerDelegate {
    // 这个 Delegate 是使用 ImagePicker 必须的，虽说可以什么都不写
}
