import UIKit

class PreviewViewController: UIViewController {

    // 由调用方填写
    var url: URL!
    var delegate: SafelightDelegate?

    var imageView: UIImageView!
    var messageLabel: UILabel!
    var isSure = false
    var score: Int?
    var orderState: OrderState!
    var price: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "预览"
        let item = UIBarButtonItem(title: "重新拍摄", style: .plain, target: self,
                                   action: #selector(PreviewViewController.reShoot))
        self.navigationItem.rightBarButtonItem = item
        self.view.backgroundColor = UIColor(rgbValue: 0x4da4e1)

        let space = self.view.frame.width

        let imgData = try? Data(contentsOf: url)
        let showImg = UIImage(data: imgData!)
        let width = (300/(showImg?.size.height)!)*(showImg?.size.width)!
        let imageView = UIImageView(frame: CGRect(x: (self.view.frame.width-width)/2, y: 45, width: width, height: 300))
        imageView.image = showImg
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 6.0
        self.view.addSubview(imageView)
        self.imageView = imageView

        let messageLabel = UILabel(frame: CGRect(x: 0, y: imageView.frame.maxY+15,
            width: self.view.frame.width, height: 30))
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .center
        messageLabel.text = "预览照片包含水印\n确认照片满意后点击确定按钮"
        self.view.addSubview(messageLabel)
        self.messageLabel = messageLabel

        // 支付
        let saveBtn = UIButton(frame: CGRect(x: space/2-42,
            y: messageLabel.frame.maxY+40, width: 84, height: 25))
        saveBtn.setTitle("确定", for: UIControlState())
        saveBtn.setTitleColor(UIColor.white, for: UIControlState())
        saveBtn.backgroundColor = UIColor(rgbValue: 0x0b83e2)
        saveBtn.layer.cornerRadius = 5.0
        saveBtn.addTarget(self,
                          action: #selector(PreviewViewController.commitOrder),
                          for: UIControlEvents.touchUpInside)
        self.view.addSubview(saveBtn)
    }

    func commitOrder(_ sender: UIButton) {
        if isSure {
            searchDetail()
        } else {
            sender.setTitle("保存", for: UIControlState())
            self.messageLabel.text = "预览照片包含水印确认照片满意后\n支付即可保存照片"
            isSure = true
        }
    }

    func searchDetail() {
        Protocol.sharedInstance.createOrder(MSAfx.taskId) { [weak self] order, error in

            guard let strongSelf = self else { return }

            MSAfx.loadingView.hide(nil)

            if let order = order {
                MSAfx.orderNo = order.orderNo
                self!.orderState = order.state
                self!.price = order.price
                strongSelf.searchOrderStatus()
            } else {
                let message = error?.localizedDescription ?? "未知错误"
                strongSelf.showDetail(message, type: 1)
            }        }
    }

    func showDetail(_ message: String, type: Int) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let retry = UIAlertAction(title: "重试", style: .default) { [weak self] action in
            guard let strongSelf = self else { return }
            if type == 1 {
                strongSelf.searchDetail()
            } else {
                strongSelf.searchOrderStatus()
            }
        }
        alert.addAction(retry)

        let abort = UIAlertAction(title: "放弃", style: .destructive) { [weak self] action in
            guard let strongSelf = self else { return }

            strongSelf.delegate?.safelightFinished(error: SafelightError.userCancelled.error())
            strongSelf.navigationController!.dismiss(animated: true, completion: nil)
        }
        alert.addAction(abort)

        self.present(alert, animated: true, completion: nil)
    }

    func reShoot() {
        for ele in self.navigationController!.viewControllers {
            if let cameraVC = ele as? CameraViewController {
                // 返回拍摄界面
                NavigationController.setPortrait(false, controller: self)
                self.navigationController?.popToViewController(
                    cameraVC,
                    animated: false)
                break
            }
        }
    }

    func searchOrderStatus() {
        if orderState.rawValue == "paid" {
            Protocol.sharedInstance.getURLofOrder(MSAfx.orderNo) { [weak self] url, error in
                
                guard let strongSelf = self else { return }
                
                MSAfx.loadingView.hide(nil)
                
                if let url = url {
                    if let data = try? Data(contentsOf: url),
                        let image = UIImage(data: data) {
                        strongSelf.delegate?.safelightFinished(image: image, score: strongSelf.score!)
                        strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                    } else {
                        let message = "网络请求失败，请重试"
                        strongSelf.showDetail(message, type: 2)
                    }
                } else {
                    let message = error?.localizedDescription ?? "未知错误"
                    strongSelf.showDetail(message, type: 2)
                }
            }
        } else {
            let alert = UIAlertController(title: nil, message: "设置错误，请联系开发者", preferredStyle: .alert)
            
            let abort = UIAlertAction(title: "确定", style: .destructive) { [weak self] action in
                guard let strongSelf = self else { return }
                
                strongSelf.delegate?.safelightFinished(error: SafelightError.moneyError.error())
                strongSelf.navigationController!.dismiss(animated: true, completion: nil)
            }
            alert.addAction(abort)
            self.present(alert, animated: true, completion: nil)
        }
    }
        
}
