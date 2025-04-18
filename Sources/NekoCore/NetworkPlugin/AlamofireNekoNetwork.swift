import Alamofire
import Foundation

public struct AlamofireNekoNetwork {
    public static func fromNekoHttp(_ req: NekoHttp) -> NekoRequest {
        return NekoRequest(
            url: req.url,
            method: req.method,
            parameters: req.parameters ?? [String: String](),
            headers: req.headers ?? [String: String](),
            body: req.body
        )
    }

    public static func send(_ req: NekoRequest, _ encoding: String.Encoding = .utf8) async throws
        -> NekoResponse
    {
        let urlRequest = try buildRequest(req, encoding)
        let res = await AF.request(urlRequest).redirect(using: .follow)
        let body = res.data == nil ? nil : String(data: res.data!, encoding: encoding)

        return NekoResponse(
            url: req.url,
            method: req.method,
            parameters: req.parameters,
            headers: [String: String](),
            body: body,
            statusCode: res.response?.statusCode ?? 0,
            metadata: NekoResponseMetadata()
        )
    }

    public static func buildRequest(_ http: NekoRequest, _ encoding: String.Encoding = .utf8) throws
        -> URLRequest
    {
        guard var url = URL(string: http.url) else {
            throw NekoNetworkError.UnableToParseURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = http.method

        let queryItems = http.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        url.append(queryItems: queryItems)

        http.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        if let body = http.body {
            request.httpBody = body.data(using: encoding)
        }
        return request
    }
}
