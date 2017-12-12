import UIKit

//这个VM专门用来处理图片
class MUGImageVM: NSObject {

    //原图数据
    dynamic var lastImgFix: UIImage!
    //大框数据
    var area: CGRect!

    //最后一次合成图像
    var backColors: [UIColor]!

    //遮罩图
    //记住第一次从王友金获得要外扩
    //匹配大图大小
    dynamic var maskImage: UIImage!

    init(cont: CAMPicContext) {
        super.init()

        lastImgFix = cont.lastImgFix ?? cont.oriImg
        area = (cont.param["area"] as? NSValue ?? NSValue()).cgRectValue
    }

    init(from: MUGImageVM) {
        super.init()

        lastImgFix = from.lastImgFix
        area = from.area
        maskImage = from.maskImage
    }

    //获取扩展图
    func lastExtImg() -> UIImage {
        return self.getMixImg(lastImgFix, mask: nil, backClr: nil)
    }

    func lastMixImg() -> UIImage {
        return self.getMixImg(lastImgFix, mask: maskImage, backClr: nil)
    }

    fileprivate func getMixImg(_ oriImg: UIImage, mask: UIImage!,
        backClr: [UIColor]!) -> UIImage {
            UIGraphicsBeginImageContext(area.size)
            var g = UIGraphicsGetCurrentContext()

            //纯色背景
            UIColor(white: 128 / 255.0, alpha: 1).setFill()
            g?.fill(CGRect(
                    x: 0, y: 0, width: area.width, height: area.height
                )
            )

            //原图指定位置
            oriImg.draw(at: area.origin)

            var ret: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            //如果有mask则套用
            if mask != nil {
                ret = ret.maskImage(mask)
            }

            //如果有渐变则重上底色
            if backClr != nil {
                UIGraphicsBeginImageContext(area.size)
                g = UIGraphicsGetCurrentContext()

                //绘制渐变底色
                let clr = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                    colors: [backClr[0].cgColor, backClr[1].cgColor] as CFArray, locations: nil)

                g?.drawLinearGradient(clr!,
                    start: CGPoint(x: area.width / 2.0, y: 0),
                    end: CGPoint(x: area.width / 2.0, y: area.height),
                    options: CGGradientDrawingOptions(rawValue: 0)
                )

                //上图
                ret.draw(at: CGPoint.zero)

                ret = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }

            return ret
    }

    //这个地方需要修改传入背景色和裁剪框
    //这个裁剪框就是王友金那种噢！
    func getMixImg(_ backClr: [UIColor], clip: CGRect) -> UIImage {
        let ret = getMixImg(lastImgFix, mask: maskImage, backClr: backClr)
        return UIImage(cgImage:
            ret.cgImage!.cropping(to: CGRect(
                    x: clip.minX + area.minX, y: clip.minY + area.minY,
                    width: clip.width, height: clip.height)
                )!
        )
    }
}
