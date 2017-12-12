import UIKit

class MSJYManager: MSJYManager_OC {
    //预处理
    func pretreat(_ imageIn: UIImage, photoParm: Spec) -> Int {
        super.setMode(MSAfx.spec.isMarriage())

        MSAfx.contextImage = super.renLianShu(imageIn)
        let faceCount = MSAfx.contextImage.int(forKey: "count")
        if Int32(MSAfx.spec.numFaces) == faceCount {
            super.jiSuanKuang()
            MSAfx.modelImage = MUGImageVM(cont: MSAfx.contextImage)
            MSAfx.imageExt = MSAfx.modelImage.lastMixImg()
            super.sheZhiTuPian(MSAfx.imageExt)
            super.daFeng()
        }
        return Int(faceCount)
    }
}
