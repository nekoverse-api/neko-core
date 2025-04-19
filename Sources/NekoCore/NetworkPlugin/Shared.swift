import Foundation

extension NekoCore {
    public enum NekoNetworkError: Error {
        case UnableToParseURL
    }

    public static func fromNekoHttp(_ req: NekoHttp) -> NekoRequest {
        return NekoRequest(
            url: req.url,
            method: req.method,
            parameters: req.parameters ?? [String: String](),
            headers: req.headers ?? [String: String](),
            body: req.body
        )
    }

    public static func buildRequest(_ http: NekoRequest, _ encoding: String.Encoding = .utf8) throws
        -> URLRequest
    {
        guard var url = URL(string: http.url) else {
            throw NekoNetworkError.UnableToParseURL
        }

        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = http.method

        let queryItems = http.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        url.append(queryItems: queryItems)

        http.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        if let body = http.body {
            request.httpBody = body.data(using: encoding)
        }
        return request
    }

    public struct Shared {
        public static func durationBetweenDates(_ start: Date?, _ end: Date?) -> Duration {
            guard let start else { return .microseconds(0) }
            guard let end else { return .microseconds(0) }

            return .seconds(start.distance(to: end))
        }
    }
}
