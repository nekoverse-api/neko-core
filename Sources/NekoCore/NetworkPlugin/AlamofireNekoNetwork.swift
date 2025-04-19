import Alamofire
import Foundation

extension NekoCore {
    public struct AlamofireNekoNetwork {
        public static func send(_ req: NekoRequest, _ encoding: String.Encoding = .utf8)
            async throws
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

            var responseHeaders = [String: String]()
            if let httpResponse = res.response {
                for (key, value) in httpResponse.allHeaderFields {
                    guard let key = key as? String else { continue }
                    guard let value = value as? String else { continue }
                    responseHeaders[key] = value
                }
            }

            let body = res.data == nil ? nil : String(data: res.data!, encoding: encoding)
            clock.addCheckpoint(.Process)

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
            var sent = NekoHttpSize(header: 0, body: 0)
            var received = NekoHttpSize(header: 0, body: 0)

            var local = NekoResponseMetadataNetworkServer(address: "", port: 0)
            var remote = NekoResponseMetadataNetworkServer(address: "", port: 0)

            var httpVersion = ""
            var domainResolutionProtocol = ""

            var tlsProtocolVersion = ""
            var tslCipherSuite = ""

            if let metrics {
                let length = metrics.transactionMetrics.count
                let metric = metrics.transactionMetrics[length - 1]

                // Size
                sent.header = metric.countOfRequestHeaderBytesSent
                sent.body = metric.countOfRequestBodyBytesSent

                received.header = metric.countOfResponseHeaderBytesReceived
                received.body = metric.countOfResponseBodyBytesReceived

                // Network
                httpVersion = metric.networkProtocolName ?? ""
                domainResolutionProtocol = getDomainResolutionProtocolName(
                    metric.domainResolutionProtocol)

                local.address = metric.localAddress ?? ""
                local.port = metric.localPort ?? 0

                remote.address = metric.remoteAddress ?? ""
                remote.port = metric.remotePort ?? 0

                if let protocolVersion = metric.negotiatedTLSProtocolVersion {
                    tlsProtocolVersion = getProtocolVersionName(protocolVersion)
                }

                if let cipherSuite: tls_ciphersuite_t = metric.negotiatedTLSCipherSuite {
                    tslCipherSuite = getCipherSuiteName(cipherSuite)
                }
            }

            return NekoResponseMetadata(
                time: [NekoPhase: Duration](),
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
