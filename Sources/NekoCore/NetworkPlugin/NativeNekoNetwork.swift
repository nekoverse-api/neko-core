import Foundation

public enum NekoNetworkError: Error {
    case UnableToParseURL
}

public struct NativeNekoNetwork {
    public struct NekoNetworkMeasurement {
        let clock: ContinuousClock = ContinuousClock()
        var time = [NekoPhase: Duration]()

        var start: ContinuousClock.Instant
        var end: ContinuousClock.Instant

        public init() {
            self.start = clock.now
            self.end = self.start
        }

        mutating func addCheckpoint(_ phase: NekoPhase) {
            self.end = clock.now
            self.time[phase] = start.duration(to: self.end)
            self.start = self.end
        }

        func getTimeMeasurement() -> [NekoPhase: Duration] {
            return time
        }
    }

    public static func send(_ req: NekoRequest, _ encoding: String.Encoding = .utf8) async throws
        -> NekoResponse
    {
        var clock = NekoNetworkMeasurement()
        let urlRequest = try buildRequest(req, encoding)
        clock.addCheckpoint(.Prepare)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        clock.addCheckpoint(.Download)

        var statusCode = 0
        var responseHeaders = [String: String]()
        if let httpResponse = response as? HTTPURLResponse {
            statusCode = httpResponse.statusCode

            for (key, value) in httpResponse.allHeaderFields {
                guard let key = key as? String else { continue }
                guard let value = value as? String else { continue }
                responseHeaders[key] = value
            }
        }
        clock.addCheckpoint(.Process)

        let size = NekoSize(
            req: NekoHttpSize(header: 0, body: Int64(urlRequest.httpBody?.count ?? 0)),
            res: NekoHttpSize(header: 0, body: Int64(data.count))
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
            headers: responseHeaders,
            body: String(data: data, encoding: encoding),
            statusCode: statusCode,
            metadata: metadata
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
