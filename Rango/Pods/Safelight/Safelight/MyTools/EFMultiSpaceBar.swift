//
//  EFMultiSpaceBar.swift
//  mugshot
//
//  Created by dexter on 15/4/27.
//  Copyright (c) 2015年 dexter. All rights reserved.
//

import UIKit
import SnapKit

class EFMultiSpaceBar: UIView {

    var sec1: Int = 35
    var sec2: Int = 80

    @IBInspectable var multi: Int = 5
    @IBInspectable var frontColor: UIColor {
        get {
            return frontView.backgroundColor!
        }
        set {
            frontView.backgroundColor = newValue
        }
    }
    @IBInspectable var duration100: Double = 1.0

    fileprivate weak var frontView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        chuShiHua()
    }

    required
    init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        chuShiHua()
    }

    fileprivate func chuShiHua() {
        backgroundColor = UIColor(white: 211 / 255.0, alpha: 1)

        let view = UIView()
        view.backgroundColor = UIColor.black
        self.addSubview(view)

        view.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(0)
        }
        frontView = view
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        cutWithPoints(self, number: multi)
    }

    //剪切
    fileprivate func cutWithPoints(_ view: UIView, number: Int) {
        //切块
        if 1 < number {
            //间距
            let margin: CGFloat = 1.0

            //拆分
            let step = view.frame.width / CGFloat(number)
            let height = view.frame.height

            //遮罩
            let maskLayer = CAShapeLayer()
            let path = CGMutablePath()
            for i in 0..<number {
                path.addRect(CGRect(
                    x: step * CGFloat(i), y: 0,
                    width: step - ((i + 1) == number ? 0.0 : margin),
                    height: height
                ))
                //                CGPathAddRect(
                //                    path, nil,
                //                    CGRect(
                //                        x: step * CGFloat(i), y: 0,
                //                        width: step - ((i + 1) == number ? 0.0 : margin),
                //                        height: height
                //                    )
                //                )
            }
            maskLayer.path = path
            view.layer.mask = maskLayer
        }

        //圆角矩形
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 1.0
    }

    //只能放在didApear里
    func countToValue(_ value: Int, clr: [UIColor]? = nil, duration: Double!) {
        if clr != nil {
            frontView.backgroundColor = clr![0]
        }
        if value == 0 {
            return
        }
        let per = Double(value) / 100.0
        let durad = duration100 / 100.0
        let dura = duration ?? (durad * Double(value))

        layoutIfNeeded()
        UIView.animate(
            withDuration: dura,
            delay: 0,
            options: .curveLinear,
            animations: {
                [weak self] in
                if let strongSelf = self {
                    strongSelf.frontView.snp.remakeConstraints {
                        //                        ("Unknown", line: 0)
                        make in
                        make.left.top.bottom.equalTo(strongSelf)
                        make.width.equalTo(strongSelf).multipliedBy(per)
                    }
                    strongSelf.layoutIfNeeded()
                }
            }, completion: nil)

        if clr == nil || value < sec1 {
            return
        }

        let dura2 = durad * Double(sec1)
        let dura3 = durad * Double(sec2)

        UIView.animateKeyframes(
            withDuration: dura,
            delay: 0,
            options: .calculationModeDiscrete,
            animations: {
                [weak self] in
                if let strongSelf = self {
                    UIView.addKeyframe(
                        withRelativeStartTime: dura2 / dura,
                        relativeDuration: 0
                        ) {
                            strongSelf.frontView.backgroundColor = clr![1]
                    }
                    if value >= strongSelf.sec2 {
                        UIView.addKeyframe(
                            withRelativeStartTime: dura3 / dura,
                            relativeDuration: 0
                            ) {
                                strongSelf.frontView.backgroundColor = clr![2]
                        }
                    }
                }
            }, completion: nil)
    }
}
