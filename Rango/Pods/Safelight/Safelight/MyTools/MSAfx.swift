import UIKit
import CryptoSwift


// 显示模式:单人/多人
enum DisplayMode {
    case normal
    case marry
}

open class MSAfx {
    // 加载
    static let loadingView = UILoadingView()

    // 套餐信息
    static var spec: Spec!

    // 图片结构
    static var contextImage: CAMPicContext!
    static var modelImage: MUGImageVM!

    // SDK 存储
    static var appKey: String!
    static var appSecret: String!
    static var specKey: String!
    static var beginColor: Int?
    static var endColor: Int?
    static var taskId: String!
    static var orderNo: String!

    // 是否需要校验
    static var isChecked = false

    // 暂存区
    static var imageExt: UIImage!
}
