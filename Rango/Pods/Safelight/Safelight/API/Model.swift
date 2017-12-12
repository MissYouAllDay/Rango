import Foundation


func uiColorFromInt(_ rgbValue: Int, alpha: CGFloat) -> UIColor {
    let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
    let green = CGFloat((rgbValue & 0x00FF00) >>  8) / 0xFF
    let blue =  CGFloat((rgbValue & 0x0000FF) >>  0) / 0xFF

    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}

func intFromUIColorWithoutAlpha(_ color: UIColor) -> Int? {
    var fRed: CGFloat = 0
    var fGreen: CGFloat = 0
    var fBlue: CGFloat = 0
    var fAlpha: CGFloat = 0
    if color.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
        let iRed = UInt(fRed * 255.0)
        let iGreen = UInt(fGreen * 255.0)
        let iBlue = UInt(fBlue * 255.0)
        let iAlpha = UInt(0)
        return Int((iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue)
    } else {
        return nil
    }
}


// 背景
struct Backdrop {
    let beginColor: UIColor
    let endColor: UIColor
}

// 摄像头朝向
enum CameraFacing: String {
    case Front = "front"
    case Rear = "rear"
}

// 屏幕朝向
enum Orientation: String {
    case Portrait = "portrait"
    case Landscape = "landscape"
}

// 规格信息
struct Spec {
    let specID: String
    let width: Int
    let height: Int
    let backdrops: [Backdrop]
    let numFaces: Int                           // 人脸数量要求
    let preferredOrientation: Orientation       // 照片朝向要求
    let preferredCameraFacing: CameraFacing?    // 摄像头朝向要求

    init?(raw: AnyObject) {
        guard let dict = raw as? [String: AnyObject] else { return nil }

        if let specID = dict["id"] as? String {
            self.specID = specID
        } else {
            return nil
        }

        if let width = dict["width"] as? Int {
            self.width = width
        } else {
            return nil
        }

        if let height = dict["height"] as? Int {
            self.height = height
        } else {
            return nil
        }

        if let rawBackdrops = dict["backdrops"] as? [[String: Int]] {
            var backdrops = [Backdrop]()
            for rawBackdrop in rawBackdrops {
                if let rawBeginColor = rawBackdrop["begin_color"],
                    let rawEndColor = rawBackdrop["end_color"] {
                    let beginColor = uiColorFromInt(rawBeginColor, alpha: 1.0)
                    let endColor = uiColorFromInt(rawEndColor, alpha: 1.0)
                    let backdrop = Backdrop(beginColor: beginColor, endColor: endColor)
                    backdrops.append(backdrop)
                } else {
                    return nil
                }
            }
            self.backdrops = backdrops
        } else {
            return nil
        }

        if let numFaces = dict["num_faces"] as? Int {
            self.numFaces = numFaces
        } else {
            return nil
        }

        if let rawPreferredOrientation = dict["preferred_orientation"] as? String,
            let preferredOrientation = Orientation(rawValue: rawPreferredOrientation) {
            self.preferredOrientation = preferredOrientation
        } else {
            return nil
        }

        if let entry = dict["preferred_camera_facing"] {
            if let rawPreferredCameraFacing = entry as? String {
                self.preferredCameraFacing = CameraFacing(rawValue: rawPreferredCameraFacing)
            } else {
                self.preferredCameraFacing = nil
            }
        } else {
            return nil
        }
    }

    func isLandscape() -> Bool {
        return self.preferredOrientation == .Landscape
    }

    func isMarriage() -> Bool {
        return self.numFaces == 2
    }
}

//证件照任务信息
struct TaskRequest {
    let image: UIImage
    let specKey: String
    let beginColor: Int?
    let endColor: Int?

    func toDictionary() -> [String: AnyObject]? {
        let quality: CGFloat = 1.0
        guard let jpegData = UIImageJPEGRepresentation(self.image, quality) else { return nil }

        let options = NSData.Base64EncodingOptions(rawValue: 0)
        let base64Data = jpegData.base64EncodedString(options: options)

        return [
            "image": base64Data as AnyObject,
            "spec_key": MSAfx.specKey as String as AnyObject,
            "begin_color": beginColor as AnyObject? ?? NSNull(),
            "end_color": endColor as AnyObject? ?? NSNull(),
        ]
    }
}

//ali_params
class AlipayParamsModel: NSObject {
    var params: String?
    
    init?(data: AnyObject?) {
        super.init()
        if nil == data {
            return nil
        }
        if let dict = (data as? NSDictionary) {
            params = dict["params"] as? String
        }
        if nil == params {
            return nil
        }
    }
}

// 任务状态
struct TaskState {
    let status: String
    let previewURL: URL?
    let description: String?
}

// 订单状态
enum OrderState: String {
    case Created = "created"
    case Paid = "paid"
}

// 创建订单
struct Order {
    let orderNo: String
    let state: OrderState
    let price: Int

    init? (raw: AnyObject) {
        guard let raw = raw as? [String: AnyObject] else { return nil }

        if let orderNo = raw["order_no"] as? String {
            self.orderNo = orderNo
        } else {
            return nil
        }

        if let rawState = raw["state"] as? String,
            let state = OrderState(rawValue: rawState) {
            self.state = state
        } else {
            return nil
        }
        
        if let price = raw["price"] as? Int {
            self.price = price
        } else {
            return nil
        }
    }
}
