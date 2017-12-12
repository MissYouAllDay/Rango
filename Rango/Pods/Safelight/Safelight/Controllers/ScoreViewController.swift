import UIKit
import SnapKit


struct ScoreEntry {
    let title: String
    let score: Int
}

class ScoreViewController: UIViewController {

    fileprivate let viewTop = UIView()
    fileprivate let viewImage = UIImageView()

    fileprivate let viewMiddle = UIView()
    fileprivate var viewsScore = [MSScoreBar]()
    fileprivate var viewScoreInfo = [ScoreEntry]()
    fileprivate var scoreViewTitles = [String]()

    fileprivate let viewBottom = UIView()
    fileprivate let viewBottomLine = EFThinLine()
    fileprivate let viewBottomMiddle = UIView()
    fileprivate let warningLabel = UILabel()

    fileprivate var mode = DisplayMode.normal

    //传递delegate
    var delegate: SafelightDelegate?
    var aveScore: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "拍摄环境评分"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        //生成分数条数据
        if let scores = MSAfx.contextImage.param["judge"] as? [Int] {
            var finalScore = 0
            for ele in scores {
                finalScore = finalScore + ele
            }
            aveScore = finalScore/scores.count
            mode = ((5 == scores.count) ? .marry : .normal)
            scoreViewTitles = (.marry == mode ?
                ["光照充足", "光线均匀", "服装突出", "身高差", "靠近度"] :
                ["光照充足", "光线均匀", "服装突出", "头部摆正"]
            )
            for (index, score) in scores.enumerated() {
                viewScoreInfo.append(
                    ScoreEntry(title: scoreViewTitles[index], score: score)
                )
            }
        }

        addControls()
        setWarningText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        for (index, value) in viewScoreInfo.enumerated() {
            viewsScore[index].score = value.score
        }
    }

    // MARK: 添加控件
    func addControls() {
        //底部
        self.view.addSubview(viewBottom)
        viewBottom.snp_makeConstraints { make in
            make.width.equalTo(view)
            make.height.equalTo(84)
            make.left.bottom.equalTo(0)
        }

        viewBottomLine.color = UIColor(rgbValue: 0xe0e0e0)
        viewBottom.addSubview(viewBottomLine)
        viewBottomLine.snp_makeConstraints { make in
            make.width.equalTo(viewBottom).offset(-80)
            make.height.equalTo(1)
            make.left.equalTo(40)
            make.top.equalTo(0)
        }

        viewBottom.addSubview(viewBottomMiddle)
        viewBottomMiddle.snp_makeConstraints { make in
            make.center.width.equalTo(viewBottom)
        }

        warningLabel.textColor = UIColor(rgbValue: 0x7a7a7a)
        warningLabel.font = UIFont.systemFont(ofSize: 14)
        warningLabel.numberOfLines = 0
        warningLabel.lineBreakMode = .byWordWrapping
        warningLabel.textAlignment = .center
        warningLabel.text = "处理中..."
        viewBottomMiddle.addSubview(warningLabel)
        warningLabel.snp_makeConstraints { make in
            make.width.equalTo(viewBottom).offset(-20)
            make.left.equalTo(10)
            make.top.equalTo(viewBottomMiddle.snp_top)
        }

        //中部
        viewMiddle.clipsToBounds = true
        self.view.addSubview(viewMiddle)
        let scoreCount = CGFloat(viewScoreInfo.count)
        viewMiddle.snp_makeConstraints { make in
            make.width.equalTo(view)
            make.height.equalTo(40 * scoreCount + 33.0).priority(999)
            make.top.greaterThanOrEqualTo(0).priorityRequired()
            make.left.equalTo(0)
            make.bottom.equalTo(viewBottom.snp_top)
        }

        var lastScoreBar: MSScoreBar!
        for value in viewScoreInfo {
            let tempScoreView = MSScoreBar()
            tempScoreView.title = value.title
            viewsScore.append(tempScoreView)
            viewMiddle.addSubview(tempScoreView)
            if let lastBar = lastScoreBar {
                tempScoreView.snp_makeConstraints { make in
                    make.width.equalTo(viewMiddle).offset(-80)
                    make.height.equalTo(40)
                    make.left.equalTo(40)
                    make.top.equalTo(lastBar.snp_bottom)
                }
            } else {
                tempScoreView.snp_makeConstraints { make in
                    make.width.equalTo(viewMiddle).offset(-80)
                    make.height.equalTo(40)
                    make.left.equalTo(40)
                    make.top.equalTo(25)
                }
            }
            lastScoreBar = tempScoreView
        }

        //顶部
        viewTop.backgroundColor = UIColor(rgbValue: 0x2196f3)
        self.view.addSubview(viewTop)
        viewTop.snp_makeConstraints { make in
            make.width.equalTo(view)
            make.left.top.equalTo(0)
            make.bottom.equalTo(viewMiddle.snp_top).priority(998)
        }

        //获取待显示图片
        let imgToShow: UIImage = MSAfx.modelImage.lastMixImg()
        viewImage.image = imgToShow
        viewImage.layer.borderWidth = 4
        viewImage.layer.borderColor = UIColor.white.cgColor
        viewTop.addSubview(viewImage)

        if imgToShow.size.height > imgToShow.size.width {
            viewImage.snp_makeConstraints { make in
                make.center.equalTo(viewTop)
                make.height.equalTo(viewTop).offset(-36)
                make.width.equalTo(viewImage.snp_height).dividedBy(
                    imgToShow.size.height / imgToShow.size.width
                )
            }
        } else {
            viewImage.snp_makeConstraints { make in
                make.center.equalTo(viewTop)
                make.width.equalTo(viewTop).offset(-36)
                make.height.equalTo(viewImage.snp_width).dividedBy(
                    imgToShow.size.width / imgToShow.size.height
                )
            }
        }
    }

    // MARK: 设置提示文字
    func setWarningText() {
        let warningScore = (.marry == mode ?
            [(35, 80), (35, 80), (35, 80), (60, 80), (60, 80)] :
            [(35, 80), (35, 80), (35, 80), (35, 80)]
        )
        var tipString = ""
        var tipMark = false
        for (index, value) in viewScoreInfo.enumerated() {
            viewsScore[index].setLevels(
                [warningScore[index].0, warningScore[index].1]
            )
            if value.score < warningScore[index].0 {
                tipString += ((("" == tipString) ? "" : "、") + "“"
                    + scoreViewTitles[index] + "”")
            } else if value.score < warningScore[index].1 {
                tipMark = true
            }
        }
        if "" == tipString {
            addNextButton()
            if tipMark {
                tipString = "还可以更好哦，建议重新拍摄"
            } else {
                if .normal == mode {
//                    nextClick()
                }
            }
        } else {
            tipString += "不合格，请重新拍摄"
        }
        warningLabel.text = tipString
    }

    // MARK: 导航栏
    fileprivate func addNextButton() {
        //导航栏下一步按钮
        let nextButton = UIBarButtonItem(
            title: "下一步",
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(ScoreViewController.nextClick)
        )
        nextButton.isEnabled = true
        self.navigationItem.rightBarButtonItem = nextButton
    }

    func nextClick() {
        MSAfx.loadingView.show(self, with: "正在进行图片处理")

        let request = TaskRequest(image: MSAfx.contextImage.oriImg,
                                  specKey: MSAfx.specKey,
                                  beginColor: MSAfx.beginColor,
                                  endColor: MSAfx.endColor)
        Protocol.sharedInstance.createTask(request) {
            [weak self] taskID, error in

            guard let strongSelf = self else { return }

            MSAfx.loadingView.hide(nil)

            if let taskID = taskID {
                MSAfx.taskId = taskID
                strongSelf.searchTaskInfo()
            } else {
                let message = error?.localizedDescription ?? "未知错误"
                strongSelf.showDetail(message, type: 1)
            }
        }
    }

    func showDetail(_ message: String, type: Int) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let retry = UIAlertAction(title: "重试", style: .default) { [weak self] action in
            guard let strongSelf = self else { return }
            if type == 1 {
                strongSelf.nextClick()
            } else {
                strongSelf.refreshOrderState()
            }
        }
        alert.addAction(retry)

        let abort = UIAlertAction(title: "放弃", style: .destructive) { [weak self] action in
            guard let strongSelf = self else { return }

            strongSelf.delegate?.safelightFinished(error: SafelightError.userCancelled.error())
            strongSelf.navigationController!.dismiss(animated: true, completion: nil)
        }
        alert.addAction(abort)

        self.present(alert, animated: true, completion: nil)
    }

    var times = 2.0
    func searchTaskInfo() {
        MSAfx.loadingView.show(self, with: "查询中")
        let _ = Timer.scheduledTimer(
            timeInterval: times,
            target: self,
            selector: #selector(ScoreViewController.refreshOrderState),
            userInfo: nil,
            repeats: false
        )
    }

    func refreshOrderState() {
        Protocol.sharedInstance.getTaskState(MSAfx.taskId) { [weak self] state, error in

            guard let strongSelf = self else { return }

            MSAfx.loadingView.hide(nil)

            if let state = state {
                if state.status == "SUCCESS" {
                    let controller = PreviewViewController()
                    controller.delegate = strongSelf.delegate
                    controller.score = strongSelf.aveScore
                    controller.url = state.previewURL
                    strongSelf.navigationController?.pushViewController(controller, animated: true)

                    let backItem = UIBarButtonItem()
                    backItem.title = ""
                    strongSelf.navigationItem.backBarButtonItem = backItem
                } else if state.status == "FAILURE" {
                    let message = state.description ?? "未知错误"
                    strongSelf.showDetail(message, type: 2)
                } else {
                    strongSelf.times += 2
                    strongSelf.searchTaskInfo()
                }
            } else {
                let message = error?.localizedDescription ?? "未知错误"
                strongSelf.showDetail(message, type: 2)
            }
        }
    }

    // MARK: 截获nav的默认返回事件我们自己处理
    func navigationShouldPopOnBackButton() -> Bool {
        NavigationController.setPortrait(false, controller: self)
        return true
    }
}
