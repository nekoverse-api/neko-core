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
    public var header: Int64
    public var body: Int64
}

public struct NekoSize: Codable {
    public var req: NekoHttpSize
    public var res: NekoHttpSize
}

public enum NekoPhase: String, Codable, Hashable {
    case Prepare
    case SocketInitialization
    case DnsLookup
    case TCPHandshake
    case WaitingTimeToFirstByte
    case Download
    case Process
}

public struct NekoResponseMetadata: Codable {
    public var time: [NekoPhase: Duration]?
    public var size: NekoSize?

    public var extra: [String: String]?
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
