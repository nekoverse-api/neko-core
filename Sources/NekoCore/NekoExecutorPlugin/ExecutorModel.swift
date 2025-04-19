//
// Neko Request
//
public struct NekoRequestContext {
    var version: String
}

public struct NekoRequest {
    var url: String
    var method: String

    var parameters: [String: String]
    var headers: [String: String]
    var body: String?

    var context: String?
}

//
// Neko Response
//
public struct NekoHttpSize: Codable {
    public var header: Int64  // In Bytes
    public var body: Int64  // In Bytes
}

public struct NekoSize: Codable {
    public var sent: NekoHttpSize
    public var received: NekoHttpSize
}

public enum NekoPhase: String, Codable, Hashable {
    case Prepare
    case SocketInitialization
    case DnsLookup
    case TCPHandshake
    case SSLHandshake
    case WaitingTimeToFirstByte
    case Download
    case Process

    case TOTAL
}

public struct NekoResponseMetadataNetworkServer: Codable {
    public var address: String
    public var port: Int
}

public struct NekoResponseMetadataNetwork: Codable {
    public var httpVersion: String
    public var domainResolutionProtocol: String

    public var tlsProtocolVersion: String
    public var tlsCipherSuite: String

    public var local: NekoResponseMetadataNetworkServer
    public var remote: NekoResponseMetadataNetworkServer
}

public struct NekoResponseMetadata: Codable {
    public var time: [NekoPhase: Duration]?

    public var size: NekoSize?
    public var network: NekoResponseMetadataNetwork?
}

public struct NekoResponse: Codable {
    public var url: String
    public var method: String

    public var parameters: [String: String]
    public var headers: [String: String]
    public var body: String?

    public var statusCode: Int
    public var metadata: NekoResponseMetadata
}
