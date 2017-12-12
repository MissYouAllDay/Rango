import UIKit


@objc
public protocol SafelightDelegate: NSObjectProtocol {
    func safelightFinished(image: UIImage, score: Int)
    func safelightFinished(error: NSError?)
}


@objc
open class Safelight: NSObject {

    open static let errorDomain = SafelightErrorDomain

    open static func make(key: String, secret: String, specKey: String,
                                beginColor: UIColor, endColor: UIColor,
                                viewController: UIViewController,
                                delegate: SafelightDelegate?)
    {
        let rawBeginColor = intFromUIColorWithoutAlpha(beginColor)
        let rawEndColor = intFromUIColorWithoutAlpha(endColor)
        
        if (rawBeginColor != nil && rawEndColor == nil) || (rawBeginColor == nil && rawEndColor != nil) {
            let error = SafelightError.invalidParameter("背景色参数无效").error()
            delegate?.safelightFinished(error: error)
            return
        }

        MSAfx.isChecked = false
        MSAfx.appKey = key
        MSAfx.appSecret = secret
        MSAfx.specKey = specKey
        MSAfx.beginColor = rawBeginColor
        MSAfx.endColor = rawEndColor

        let controller = NavigationController()
        controller.SDKdelegate = delegate
        
        viewController.present(controller, animated: true, completion: nil)
    }

}
