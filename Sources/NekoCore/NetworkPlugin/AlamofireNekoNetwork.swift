import Alamofire
import Foundation

extension NekoCore {
    public struct AlamofireNekoNetwork {
        public static func send(_ req: NekoRequest, _ encoding: String.Encoding = .utf8)
            async throws
            -> NekoResponse
        {
            // TODO: Review if is better use new session - NekoNetworkSession.session
            let session = Session(configuration: NekoNetworkSession.configuration)

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

            var timeInMs = [NekoPhase: String]()
            let uS = Shared.formatInMiliseconds
            timeInMs[.SocketInitialization] = uS(time[.SocketInitialization])
            timeInMs[.DnsLookup] = uS(time[.DnsLookup])
            timeInMs[.TCPHandshake] = uS(time[.TCPHandshake])
            timeInMs[.SSLHandshake] = uS(time[.SSLHandshake])
            timeInMs[.WaitingTimeToFirstByte] = uS(time[.WaitingTimeToFirstByte])
            timeInMs[.Download] = uS(time[.Download])

            timeInMs[.TOTAL] = uS(time[.TOTAL])

            // Network
            var tlsProtocolVersion = ""
            var tslCipherSuite = ""

            let httpVersion = metric.networkProtocolName ?? ""
            let domainResolutionProtocol = Shared.getDomainResolutionProtocolName(
                metric.domainResolutionProtocol)

            let local = NekoResponseMetadataNetworkServer(
                address: metric.localAddress ?? "", port: metric.localPort ?? 0
            )
            let remote = NekoResponseMetadataNetworkServer(
                address: metric.remoteAddress ?? "", port: metric.remotePort ?? 0
            )

            if let protocolVersion = metric.negotiatedTLSProtocolVersion {
                tlsProtocolVersion = Shared.getProtocolVersionName(protocolVersion)
            }

            if let cipherSuite: tls_ciphersuite_t = metric.negotiatedTLSCipherSuite {
                tslCipherSuite = Shared.getCipherSuiteName(cipherSuite)
            }

            return NekoResponseMetadata(
                time: time,
                timeInMs: timeInMs,
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

    }
}
