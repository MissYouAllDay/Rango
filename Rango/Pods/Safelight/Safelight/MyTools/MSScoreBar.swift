import UIKit


class MSScoreBar: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addControls()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addControls()
    }

    override func layoutSubviews() {
        replace()
        super.layoutSubviews()
    }

    fileprivate func addControls() {
        titleLabel.font = UIFont.systemFont(ofSize: 11)
        self.addSubview(titleLabel)

        numberLabel.text = "0"
        numberLabel.font = UIFont.systemFont(ofSize: 12)
        numberLabel.textAlignment = NSTextAlignment.right
        self.addSubview(numberLabel)

        self.addSubview(bottomBar)
    }

    fileprivate func replace() {
        titleLabel.frame = CGRect(
            origin: CGPoint(x: 0, y: 1),
            size: CGSize(width: self.frame.width / 4.0 * 3.0, height: 11)
        )
        titleLabel.textColor = UIColor(rgbValue: 0xB0B0B0)

        let numberLabelSize = CGSize(
            width: self.frame.width - titleLabel.frame.width,
            height: 12
        )
        numberLabel.frame = CGRect(
            origin: CGPoint(x: self.frame.width - numberLabelSize.width, y: 0),
            size: numberLabelSize
        )
        numberLabel.textColor = UIColor(rgbValue: 0x606060)

        bottomBar.frame = CGRect(
            origin: CGPoint(x: 0, y: titleLabel.frame.maxY + 5),
            size: CGSize(width: self.frame.width, height: 2)
        )
    }

    fileprivate let titleLabel = UILabel()
    fileprivate let numberLabel = EFCountingLabel()
    fileprivate let bottomBar = EFMultiSpaceBar()

    fileprivate let bottomBarColors: Array<UIColor> = [
        UIColor(rValue: 220, gValue: 78, bValue: 78, aValue: 1),
        UIColor(rValue: 78, gValue: 152, bValue: 220, aValue: 1),
        UIColor(rValue: 66, gValue: 193, bValue: 17, aValue: 1)
    ]

    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    var score = 0 {
        willSet {
            let duration = Double(newValue - score) / 100.0
            bottomBar.countToValue(newValue, clr: bottomBarColors, duration: duration)
            numberLabel.countFrom(CGFloat(score), endValue: CGFloat(newValue), duration: duration)
        }
    }

    //设置分数等级
    func setLevels(_ levels: [Int]) {
        bottomBar.sec1 = levels[0]
        bottomBar.sec2 = levels[1]
    }
}
