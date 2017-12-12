import UIKit


class NavigationController: UINavigationController {

    static var isPortrait = true

    var window: UIWindow?

    var SDKdelegate: SafelightDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setGlobalStyle()

        let cameraVC = CameraViewController()
        cameraVC.delegate = SDKdelegate
        self.pushViewController(cameraVC, animated: true)
    }

    func setGlobalStyle() {
        let mainColor = UIColor(rgbValue: 0x0b83e2)
        let whiteColor = UIColor.white

        if let targetWindow = self.window {
            targetWindow.tintColor = mainColor
        }

        // 导航栏
        let navigationBarProxy = UINavigationBar.appearance()
        navigationBarProxy.backgroundColor = mainColor
        navigationBarProxy.barTintColor = mainColor     // 背景色
        navigationBarProxy.tintColor = whiteColor       // 按钮、图标等颜色
        navigationBarProxy.titleTextAttributes = [
            NSForegroundColorAttributeName: whiteColor, // 标题色
            NSFontAttributeName:UIFont.systemFont(ofSize: 19)
        ]
        navigationBarProxy.barStyle = UIBarStyle.black

        //去除导航栏底边白线
        let bgImg = mainColor.createImageWithRect(
            CGSize(width: UIScreen.main.bounds.width, height: 20)
        )
        navigationBarProxy.setBackgroundImage(
            bgImg, for: .top, barMetrics: .default
        )
        navigationBarProxy.shadowImage = UIImage()

        //设置状态栏字体颜色
        UIApplication.shared.setStatusBarStyle(
            UIStatusBarStyle.lightContent, animated: false
        )
    }

    static func setPortrait(_ state: Bool, controller: UIViewController) {
        if MSAfx.spec.isLandscape() {
            //更改方向
            NavigationController.isPortrait = state

            //强制刷新方向
            UIDevice.current.setValue(
                UIInterfaceOrientation.landscapeLeft.rawValue,
                forKey: "orientation"
            )
            UIDevice.current.setValue(
                (NavigationController.isPortrait
                    ? UIInterfaceOrientation.portrait
                    : UIInterfaceOrientation.landscapeRight).rawValue,
                forKey: "orientation"
            )
        }
    }

    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return NavigationController.isPortrait
            ? UIInterfaceOrientation.portrait
            : UIInterfaceOrientation.landscapeRight
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return NavigationController.isPortrait
            ? UIInterfaceOrientationMask.portrait
            : UIInterfaceOrientationMask.landscapeRight
    }
}


// MARK: - UINavigationControllerDelegate
extension NavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                                     willShow viewController: UIViewController,
                                                            animated: Bool) {
        removeAllGestures(self)
    }

    func removeAllGestures(_ controller: UIViewController) {
        if let nav = controller.navigationController {
            nav.interactivePopGestureRecognizer?.isEnabled = false
        }

        for view in [controller.view, controller.topViewEF()] {
            if let gestures = view?.gestureRecognizers {
                for gesture in gestures {
                    view?.removeGestureRecognizer(gesture)
                }
            }
        }
    }

}
