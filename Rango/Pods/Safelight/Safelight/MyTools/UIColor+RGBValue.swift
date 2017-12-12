import UIKit

extension UIColor {

    convenience init(rValue: Int, gValue: Int, bValue: Int, aValue: CGFloat) {
        self.init(
            red: CGFloat(rValue) / 255.0,
            green: CGFloat(gValue) / 255.0,
            blue: CGFloat(bValue) / 255.0,
            alpha: aValue
        )
    }

    convenience init(rgbValue: UInt) {
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    //绘制纯色图片
    func createImageWithRect(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(CGRect(
            origin: CGPoint(x: 0, y: 0), size: size)
        )
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

//获取两个 UIColor 均值（只支持 RGB 空间颜色）
func midColor(_ color1: UIColor, color2: UIColor) -> UIColor {
    let rgbArr_1 = color1.cgColor.components
    let rgbArr_2 = color2.cgColor.components

    return UIColor(
        red: (rgbArr_1![0] + rgbArr_2![0]) / 2,
        green: (rgbArr_1![1] + rgbArr_2![1]) / 2,
        blue: (rgbArr_1![2] + rgbArr_2![2]) / 2,
        alpha: 1.0
    )
}
