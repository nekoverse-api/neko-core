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

        public static func getProtocolVersionName(_ version: tls_protocol_version_t) -> String {
            return switch version {
            case .TLSv10: "TLSv10"
            case .TLSv11: "TLSv11"
            case .TLSv12: "TLSv12"
            case .TLSv13: "TLSv13"
            case .DTLSv10: "DTLSv10"
            case .DTLSv12: "DTLSv12"
            default: "UNKNOWN"
            }
        }

        public static func getCipherSuiteName(_ ciphersuite: tls_ciphersuite_t) -> String {
            return switch ciphersuite {
            case .RSA_WITH_3DES_EDE_CBC_SHA: "RSA_WITH_3DES_EDE_CBC_SHA"
            case .RSA_WITH_AES_128_CBC_SHA: "RSA_WITH_AES_128_CBC_SHA"
            case .RSA_WITH_AES_256_CBC_SHA: "RSA_WITH_AES_256_CBC_SHA"
            case .RSA_WITH_AES_128_GCM_SHA256: "RSA_WITH_AES_128_GCM_SHA256"
            case .RSA_WITH_AES_256_GCM_SHA384: "RSA_WITH_AES_256_GCM_SHA384"
            case .RSA_WITH_AES_128_CBC_SHA256: "RSA_WITH_AES_128_CBC_SHA256"
            case .RSA_WITH_AES_256_CBC_SHA256: "RSA_WITH_AES_256_CBC_SHA256"
            case .ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA: "ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA"
            case .ECDHE_ECDSA_WITH_AES_128_CBC_SHA: "ECDHE_ECDSA_WITH_AES_128_CBC_SHA"
            case .ECDHE_ECDSA_WITH_AES_256_CBC_SHA: "ECDHE_ECDSA_WITH_AES_256_CBC_SHA"
            case .ECDHE_RSA_WITH_3DES_EDE_CBC_SHA: "ECDHE_RSA_WITH_3DES_EDE_CBC_SHA"
            case .ECDHE_RSA_WITH_AES_128_CBC_SHA: "ECDHE_RSA_WITH_AES_128_CBC_SHA"
            case .ECDHE_RSA_WITH_AES_256_CBC_SHA: "ECDHE_RSA_WITH_AES_256_CBC_SHA"
            case .ECDHE_ECDSA_WITH_AES_128_CBC_SHA256: "ECDHE_ECDSA_WITH_AES_128_CBC_SHA256"
            case .ECDHE_ECDSA_WITH_AES_256_CBC_SHA384: "ECDHE_ECDSA_WITH_AES_256_CBC_SHA384"
            case .ECDHE_RSA_WITH_AES_128_CBC_SHA256: "ECDHE_RSA_WITH_AES_128_CBC_SHA256"
            case .ECDHE_RSA_WITH_AES_256_CBC_SHA384: "ECDHE_RSA_WITH_AES_256_CBC_SHA384"
            case .ECDHE_ECDSA_WITH_AES_128_GCM_SHA256: "ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
            case .ECDHE_ECDSA_WITH_AES_256_GCM_SHA384: "ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
            case .ECDHE_RSA_WITH_AES_128_GCM_SHA256: "ECDHE_RSA_WITH_AES_128_GCM_SHA256"
            case .ECDHE_RSA_WITH_AES_256_GCM_SHA384: "ECDHE_RSA_WITH_AES_256_GCM_SHA384"
            case .ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256: "ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256"
            case .ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256:
                "ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
            case .AES_128_GCM_SHA256: "AES_128_GCM_SHA256"
            case .AES_256_GCM_SHA384: "AES_256_GCM_SHA384"
            default: "UNKNOWN"
            }
        }

        public static func getDomainResolutionProtocolName(
            _ domainResolutionProtocol: URLSessionTaskMetrics.DomainResolutionProtocol
        ) -> String {
            return switch domainResolutionProtocol {
            case .unknown: "UNKNOWN"
            case .udp: "UDP"
            case .tcp: "TCP"
            case .tls: "TLS"
            case .https: "HTTPS"
            default: "UNKNOWN"
            }
        }
    }
}
