import Foundation
import Alamofire


let SafelightErrorDomain = "us.leqi.safelight"


public enum SafelightError {

    case unknown(Int)
    case userCancelled
    case invalidParameter(String?)
    case invalidResponse
    case errorResponse(String)
    case internalError(String)
    case moneyError

    public func error() -> NSError {
        switch self {

        // 用户主动放弃
        case .userCancelled:
            let userInfo = [NSLocalizedDescriptionKey: "用户主动放弃"]
            return NSError(domain: SafelightErrorDomain,
                           code: -1001,
                           userInfo: userInfo)

        // 传入 SDK 参数错误
        case .invalidParameter(let parameter):
            let message = parameter ?? "参数无效"
            let userInfo = [NSLocalizedDescriptionKey: message]
            return NSError(domain: SafelightErrorDomain,
                           code: -1101,
                           userInfo: userInfo)

        // 网络通信时，服务器返回未知错误
        case .unknown(let code):
            let userInfo = [NSLocalizedDescriptionKey: "未知错误 \(code)"]
            return NSError(domain: SafelightErrorDomain,
                           code: -1201,
                           userInfo: userInfo)

        // 网络通信时，服务器返回无效的响应
        case .invalidResponse:
            let userInfo = [NSLocalizedDescriptionKey: "服务器响应格式错误"]
            return NSError(domain: SafelightErrorDomain,
                           code: -1202,
                           userInfo: userInfo)

        // 网络通信时，服务器明确告知的错误
        case .errorResponse(let message):
            let userInfo = [NSLocalizedDescriptionKey: message]
            return NSError(domain: SafelightErrorDomain,
                           code: -1203,
                           userInfo: userInfo)

        // SDK 内部错误
        case .internalError(let message):
            let userInfo = [NSLocalizedDescriptionKey: message]
            return NSError(domain: SafelightErrorDomain,
                           code: -1301,
                           userInfo: userInfo)

        // 账户余额不足
        case .moneyError:
            let userInfo = [NSLocalizedDescriptionKey: "账户余额不足"]
            return NSError(domain: SafelightErrorDomain,
                           code: -1501,
                           userInfo: userInfo)
        }
    }
}


extension DataRequest {
    public static func DarkroomJSONResponseSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DataResponseSerializer<Any>
    {
        return DataResponseSerializer { _, response, data, error in
            // 网络等问题
            guard error == nil else {
                return .failure(error!)
            }

            // 处理空响应的情况
            if let response = response, response.statusCode == 204 {
                return .success(NSNull())
            }

            // 检验数据长度
            guard let validData = data, validData.count > 0 else {
                return .failure(SafelightError.invalidResponse.error())
            }

            // 检验状态码
            let validStatusCodes = 200 ..< 300
            if let response = response, !validStatusCodes.contains(response.statusCode) {
                let JSON = try? JSONSerialization.jsonObject(with: validData, options: options)

                if let dict = JSON as? [String: AnyObject],
                    let message = dict["message"] as? String
                {
                    return .failure(SafelightError.errorResponse(message).error())
                } else {
                    return .failure(SafelightError.unknown(response.statusCode).error())
                }
            }

            // 尝试解析 JSON
            do {
                let JSON = try JSONSerialization.jsonObject(with: validData, options: options)
                return .success(JSON)
            } catch {
                return .failure(error as NSError)
            }
        }
    }

    @discardableResult
    public func responseDarkroomJSON(queue: DispatchQueue? = nil,
                                           options: JSONSerialization.ReadingOptions = .allowFragments,
                                           completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self
    {
        let serializer = DataRequest.DarkroomJSONResponseSerializer(options: options)
        return response(queue: queue,
                        responseSerializer: serializer,
                        completionHandler: completionHandler)
    }
}
