import Foundation

extension NekoCore {
    @available(*, deprecated, message: "It does not have easy way to get metadata")
    public struct NativeNekoNetwork {
        public static func send(_ req: NekoRequest, _ encoding: String.Encoding = .utf8)
            async throws
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
                sent: NekoHttpSize(header: 0, body: Int64(urlRequest.httpBody?.count ?? 0)),
                received: NekoHttpSize(header: 0, body: Int64(data.count))
            )
            let metadata = NekoResponseMetadata(
                time: clock.getTimeMeasurement(),
                size: size
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
    }
}
