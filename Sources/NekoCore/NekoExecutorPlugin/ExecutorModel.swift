//
// Neko Request
//
public struct NekoRequestContext {
    let version: String
}

public struct NekoRequest {
    let url: String
    let method: String

    let parameters: [String: String]
    let headers: [String: String]
    let body: String?

    let context: String?
}

//
// Neko Response
//
struct NekoHttpSize: Codable {
    let header: Int64
    let body: Int64
}

struct NekoSize: Codable {
    let req: NekoHttpSize
    let res: NekoHttpSize
}

enum NekoPhase: String, Codable, Hashable {
    case Prepare
    case SocketInitialization
    case DnsLookup
    case TCPHandshake
    case WaitingTimeToFirstByte
    case Download
    case Process
}

public struct NekoResponseMetadata: Codable {
    let time: [NekoPhase: Double]?
    let size: NekoSize?

    let extra: [String: String]
}

public struct NekoResponse: Codable {
    let url: String
    let method: String

    let parameters: [String: String]
    let headers: [String: String]
    let body: String?

    let status: Int
    let metadata: NekoResponseMetadata
}
