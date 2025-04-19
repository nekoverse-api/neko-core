import Alamofire
import Foundation

public struct AlamofireNekoNetwork {
    public static func send(_ req: NekoRequest, _ encoding: String.Encoding = .utf8) async throws
        -> NekoResponse
    {
        var clock = NekoCore.NekoNetworkMeasurement()
        let urlRequest = try NekoCore.buildRequest(req, encoding)
        clock.addCheckpoint(.Prepare)

        let res = await withCheckedContinuation { continuation in
            AF.request(urlRequest).redirect(using: .follow).responseData { apiRequest in
                continuation.resume(returning: apiRequest)
            }
        }
        clock.addCheckpoint(.Download)

        let body = res.data == nil ? nil : String(data: res.data!, encoding: encoding)
        clock.addCheckpoint(.Process)

        let size = NekoSize(
            req: NekoHttpSize(header: 0, body: Int64(urlRequest.httpBody?.count ?? 0)),
            res: NekoHttpSize(header: 0, body: Int64(res.data?.count ?? 0))
        )
        let metadata = NekoResponseMetadata(
            time: clock.getTimeMeasurement(),
            size: size,
            extra: [String: String]()
        )
        return NekoResponse(
            url: req.url,
            method: req.method,
            parameters: req.parameters,
            headers: [String: String](),
            body: body,
            statusCode: res.response?.statusCode ?? 0,
            metadata: metadata
        )
    }
}
