import UIKit
import Accelerate

extension UIImage {

    //从url初始化图片
    convenience init?(url: String) {
        var choice = false
        let ns = URL(string: url)
        var nd: Data!
        if ns != nil {
            nd = try? Data(contentsOf: ns!)
            if nd != nil {
                choice = true
            }
        }
        if choice {
            self.init(data: nd!)
        } else {
            self.init(named: "menu_init")
        }
    }

    static func colorImageFromPath(_ path: UIBezierPath, clr: UIColor,
        scale: CGFloat = 0.0) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(
                path.bounds.size, false, scale)

            clr.setFill()
            path.fill()

            let ret = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return ret!
    }

    //给图添加遮罩
    func maskImage(_ maskImage: UIImage) -> UIImage {
        let maskRef = maskImage.cgImage
        let mask = CGImage(maskWidth: (maskRef?.width)!,
            height: (maskRef?.height)!,
            bitsPerComponent: (maskRef?.bitsPerComponent)!,
            bitsPerPixel: (maskRef?.bitsPerPixel)!,
            bytesPerRow: (maskRef?.bytesPerRow)!,
            provider: (maskRef?.dataProvider!)!, decode: nil, shouldInterpolate: true)

        var imageWithAlpha = (self.copy() as? UIImage ?? UIImage()).cgImage

        //哈哈哈哈哈哈哈，每次都添加通道，不然 70％ 几率崩溃
        //if (CGImageGetAlphaInfo(imageWithAlpha) == .None) {
        imageWithAlpha = addAlphaChannel(imageWithAlpha!)
        //}
        let masked = imageWithAlpha?.masking(mask!)
        return UIImage(cgImage: masked!)
    }

    //裁剪出一部分
    func caijianWithRect(_ previewVM: MUGImageVM) -> UIImage {
        let rect = CGRect(
            x: previewVM.area.minX,
            y: previewVM.area.height - previewVM.area.minY
                - previewVM.lastImgFix.size.height
                + (self.size.height - previewVM.lastImgFix.size.height),
            width: previewVM.lastImgFix.size.width,
            height: previewVM.lastImgFix.size.height
        )

        return (self.cropImage(with: rect))
            .resize(with: self.size, in: rect)
    }
}

//给图片添加alpha通道，这个函数不知道有木有问题...
func addAlphaChannel(_ sourceImage: CGImage) -> CGImage {
    let width =  sourceImage.width
    let height =  sourceImage.height
    let colorSpace =  CGColorSpaceCreateDeviceRGB()

    let offscreenContext =  CGContext(data: nil, width: width, height: height,
        bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )

    offscreenContext?.draw(sourceImage, in: CGRect(x: 0, y: 0, width: width, height: height))
    return offscreenContext!.makeImage()!
}

//绘制渐变图片
func createGradientImage(_ colorBegin: UIColor, colorEnd: UIColor,
    size: CGSize) -> UIImage {
        //获取rgb
        let components_begin = colorBegin.cgColor.components
        let components_end = colorEnd.cgColor.components

        //创建渐变规则
        let rgb: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: [CGFloat] = [
            components_begin![0], components_begin![1], components_begin![2], 1.00,
            components_end![0], components_end![1], components_end![2], 1.00,
        ]

        //画图
        UIGraphicsBeginImageContext(size)
        UIGraphicsGetCurrentContext()?.drawLinearGradient(CGGradient(colorSpace: rgb, colorComponents: colors, locations: nil, count: 2)!,
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: 0, y: size.height),
            options: CGGradientDrawingOptions(rawValue: 1))
        let rtImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rtImage!
}

func getMixImg(_ oriImg: UIImage, mask: UIImage!, backClr: [UIColor]!,
    area: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(area.size)
        var g = UIGraphicsGetCurrentContext()

        //纯色背景
        UIColor(white: 128 / 255.0, alpha: 1).setFill()
        g?.fill(CGRect(x: 0, y: 0, width: area.width, height: area.height)
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
