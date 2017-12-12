import Foundation
import Alamofire


// API 基础 URL，包括所有 API 节点
let BaseURL = URL(string: "https://api.sdk.camcap.us/")!
// let BaseURL = NSURL(string: "http://192.168.1.105:5000/api")!

// API 节点，用来拼接生成 URL
enum Endpoint {
    case spec(String)
    case tasks
    case taskState(String)
    case orders
    case order(String)
    case payOrder(String)

    func url() -> URL {
        switch self {
        case .spec(let specKey):
            return BaseURL.appendingPathComponent("specs/\(specKey)")

        case .tasks:
            // TODO: 让服务器把 create 去掉
            return BaseURL.appendingPathComponent("tasks/create")

        case .taskState(let taskID):
            return BaseURL.appendingPathComponent("tasks/\(taskID)/state")

        case .orders:
            // TODO: 让服务器把 create 去掉
            return BaseURL.appendingPathComponent("orders/create")

        case .order(let orderID):
            return BaseURL.appendingPathComponent("orders/\(orderID)")
            
        case .payOrder(let orderN):
            return BaseURL.appendingPathComponent("orders/\(orderN)/alipay_params")
        }
    }
}


class Protocol {

    static let sharedInstance = Protocol()

    fileprivate var manager: SessionManager!

    init() {
        let configuration = URLSessionConfiguration.default
        manager = SessionManager(configuration: configuration)
    }

    // 获取签名
    func sign(_ params: [String: AnyObject]) -> [String: String] {
        let timestamp = Int(Date().timeIntervalSince1970)

        var sign_params = params
        
        for (key, value) in params {
            if value as! NSObject == NSNull() {
                sign_params.updateValue("null" as AnyObject, forKey: key)
            }
        }
        
        let ext_params: [String: String] = [
            "app_key": MSAfx.appKey,
            "app_secret": MSAfx.appSecret,
            "timestamp": String(timestamp),
        ]
        
        for (key, value) in ext_params {
            sign_params.updateValue(value as AnyObject, forKey: key)
        }

        let sortedKV = sign_params.sorted { $0.0 < $1.0 }
        let payload = sortedKV.map({ "\($0.0)\($0.1)" }).joined(separator: "")
        let signature = payload.md5()

        return [
            "X-App-Key": MSAfx.appKey,
            "X-App-Signature": signature,
            "X-Timestamp": String(timestamp),
        ]
    }

    // 获取规格信息
    func getSpecInfo(_ specKey: String, finish: @escaping (Spec?, NSError?) -> Void) {
        let headers = sign([:])
        print("url====\(Endpoint.spec(specKey).url())")
        manager.request(Endpoint.spec(specKey).url(), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseDarkroomJSON() { response in
                switch response.result {
                case .success(let data):
                    if let dict = data as? [String: AnyObject],
                        let rawSpec = dict["spec"],
                        let spec = Spec(raw: rawSpec) {
                        finish(spec, nil)
                    } else {
                        debugPrint(data)
                        finish(nil, SafelightError.invalidResponse.error())
                    }

                case .failure(let error):
                    finish(nil, error as NSError?)
                }
            }
    }

    // 创建证件照处理任务
    func createTask(_ request: TaskRequest, finish: @escaping (String?, NSError?) -> Void) {
        guard let params = request.toDictionary() else {
            finish(nil, SafelightError.internalError("本地图片序列化失败").error())
            return
        }

        let headers = sign(params)
        manager.request(Endpoint.tasks.url(), method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDarkroomJSON() { response in
                switch response.result {
                case .success(let data):
                    if let dict = data as? [String: AnyObject],
                        let taskID = dict["task_id"] as? String {
                        finish(taskID, nil)
                    } else {
                        debugPrint(data)
                        finish(nil, SafelightError.invalidResponse.error())
                    }

                case .failure(let error):
                    finish(nil, error as NSError?)
                }
        }
    }

    // 获取任务信息
    func getTaskState(_ taskId: String, finish: @escaping (TaskState?, NSError?) -> Void) {
        let headers = sign([:])
        manager.request(Endpoint.taskState(taskId).url(), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseDarkroomJSON() { response in
                switch response.result {
                case .success(let data):
                    if let dict = data as? [String: AnyObject],
                        let status = dict["status"] as? String,
                        let rawPreviewURL = dict["image_preview_url"] {

                        var previewURL: URL?
                        if let rawPreviewURL = rawPreviewURL as? String {
                            previewURL = URL(string: rawPreviewURL)
                        }

                        var description: String?
                        if let rawDescription = dict["description"] {
                            description = rawDescription as? String
                        }

                        let state = TaskState(status: status, previewURL: previewURL, description: description)

                        finish(state, nil)
                    } else {
                        debugPrint(data)
                        finish(nil, SafelightError.invalidResponse.error())
                    }

                case .failure(let error):
                    finish(nil, error as NSError?)
                }
            }
    }

    // 创建订单
    func createOrder(_ taskId: String, finish: @escaping (Order?, NSError?) -> Void) {
        let params = ["task_id": taskId]
        let headers = sign(params as [String : AnyObject])
        manager.request(Endpoint.orders.url(), method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDarkroomJSON() { response in
                switch response.result {
                case .success(let data):
                    if let dict = data as? [String: AnyObject],
                        let rawOrder = dict["order"] as? [String: AnyObject],
                        let order = Order(raw: rawOrder as AnyObject) {
                        finish(order, nil)
                    } else {
                        finish(nil, SafelightError.invalidResponse.error())
                    }

                case .failure(let error):
                    finish(nil, error as NSError?)
                }
            }
    }

    // 获取订单对应的证件照
    func getURLofOrder(_ orderNo: String, finish: @escaping (URL?, NSError?) -> Void) {
        let headers = sign([:])
        manager.request(Endpoint.order(orderNo).url(), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseDarkroomJSON() { response in
                switch response.result {
                case .success(let data):
                    if let dict = data as? [String: AnyObject],
                        let rawImageURL = dict["processed_image_url"] as? String {

                        if let url = URL(string: rawImageURL) {
                            finish(url, nil)
                        } else {
                            finish(nil, SafelightError.invalidResponse.error())
                        }
                    } else {
                        debugPrint(data)
                        finish(nil, SafelightError.invalidResponse.error())
                    }
                case .failure(let error):
                    finish(nil, error as NSError?)
                }
            }
    }
    
    //获取支付宝支付参数
    func getAlipayParams(_ orderNo: String, finish: @escaping (AlipayParamsModel?, NSError?) -> Void) {
        let headers = sign([:])
        manager.request(Endpoint.payOrder(orderNo).url(), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseDarkroomJSON { response in
            switch response.result {
            case .success(let data):
                if let dict = data as? NSDictionary {
                    let res: AlipayParamsModel? = AlipayParamsModel(
                        data: dict["alipay"] as AnyObject?
                    )
                    finish(res, nil)
                } else {
                    finish(nil, SafelightError.invalidResponse.error())
                }
            case .failure(let error):
                finish(nil, error as NSError?)
            }
        }
    }
}
