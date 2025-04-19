import Alamofire
// import AlamofireNetworkActivityLogger
import Foundation

extension NekoCore {
    public struct AlamofireNekoNetwork {
        public static func send(_ req: NekoRequest, _ encoding: String.Encoding = .utf8)
            async throws
            -> NekoResponse
        {
            // TODO: Review if is better use new session - Session(configuration: NekoNetworkSession.configuration)
            let session = NekoNetworkSession.session

            let urlRequest = try NekoCore.buildRequest(req, encoding)
            let res = await withCheckedContinuation { continuation in
                session.request(urlRequest).redirect(using: .follow).responseData {
                    apiRequest in
                    continuation.resume(returning: apiRequest)
                }
            }

            var responseHeaders = [String: String]()
            if let httpResponse = res.response {
                for (key, value) in httpResponse.allHeaderFields {
                    guard let key = key as? String else { continue }
                    guard let value = value as? String else { continue }
                    responseHeaders[key] = value
                }
            }

            var body: String? = nil
            if let data = res.data {
                body = String(data: data, encoding: encoding)
            }

            return NekoResponse(
                url: req.url,
                method: req.method,
                parameters: req.parameters,
                headers: responseHeaders,
                body: body,
                statusCode: res.response?.statusCode ?? 0,
                metadata: getMetadataFromMetrics(res.metrics)
            )
        }

        public static func getMetadataFromMetrics(_ metrics: URLSessionTaskMetrics?)
            -> NekoResponseMetadata
        {
            guard let metrics else { return NekoResponseMetadata() }

            let length = metrics.transactionMetrics.count
            let metric = length > 0 ? metrics.transactionMetrics[length - 1] : nil
            guard let metric else {
                return NekoResponseMetadata()
            }

            // Size
            let sent = NekoHttpSize(
                header: metric.countOfRequestHeaderBytesSent,
                body: metric.countOfRequestBodyBytesSent
            )
            let received = NekoHttpSize(
                header: metric.countOfResponseHeaderBytesReceived,
                body: metric.countOfResponseBodyBytesReceived
            )

            // Time
            var time = [NekoPhase: Duration]()
            let diff = Shared.durationBetweenDates
            let secureConnectionEndDate = metric.secureConnectionEndDate

            time[.SocketInitialization] = diff(metric.fetchStartDate, metric.domainLookupStartDate)
            time[.DnsLookup] = diff(metric.domainLookupStartDate, metric.domainLookupEndDate)
            time[.TCPHandshake] = diff(metric.connectStartDate, metric.secureConnectionStartDate)
            time[.SSLHandshake] = diff(metric.secureConnectionStartDate, secureConnectionEndDate)
            time[.WaitingTimeToFirstByte] = diff(secureConnectionEndDate, metric.responseStartDate)
            time[.Download] = diff(metric.responseStartDate, metric.responseEndDate)

            time[.TOTAL] = diff(metric.fetchStartDate, metric.responseEndDate)

            // Network
            var tlsProtocolVersion = ""
            var tslCipherSuite = ""

            let httpVersion = metric.networkProtocolName ?? ""
            let domainResolutionProtocol = getDomainResolutionProtocolName(
                metric.domainResolutionProtocol)

            let local = NekoResponseMetadataNetworkServer(
                address: metric.localAddress ?? "", port: metric.localPort ?? 0
            )
            let remote = NekoResponseMetadataNetworkServer(
                address: metric.remoteAddress ?? "", port: metric.remotePort ?? 0
            )

            if let protocolVersion = metric.negotiatedTLSProtocolVersion {
                tlsProtocolVersion = getProtocolVersionName(protocolVersion)
            }

            if let cipherSuite: tls_ciphersuite_t = metric.negotiatedTLSCipherSuite {
                tslCipherSuite = getCipherSuiteName(cipherSuite)
            }

            return NekoResponseMetadata(
                time: time,
                size: NekoSize(sent: sent, received: received),
                network: NekoResponseMetadataNetwork(
                    httpVersion: httpVersion,
                    domainResolutionProtocol: domainResolutionProtocol,
                    tlsProtocolVersion: tlsProtocolVersion,
                    tlsCipherSuite: tslCipherSuite,
                    local: local,
                    remote: remote
                )
            )
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
