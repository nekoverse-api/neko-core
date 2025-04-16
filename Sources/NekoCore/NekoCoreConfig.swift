public struct NekoPlugin: Codable {
    let name: String?
    let properties: [String: String]
}

public struct NekoFolderMetadata: Codable {
    let version: String?
    let authors: [String]?

    let name: String?
    let description: String?
    let seq: Int64?

    let loader: NekoPlugin?
    let executor: NekoPlugin?
    let tester: NekoPlugin?
}

public struct NekoRequestMetadata: Codable {
    let version: String?
    let authors: [String]?

    let name: String?
    let description: String?
    let seq: Int64?

    let loader: NekoPlugin?
    let executor: NekoPlugin?
    let tester: NekoPlugin?
}

public typealias NekoData = [[String: String]]  // TODO: Review
public typealias NekoEnvironment = [String: String]

public struct NekoFolderConfig: Codable {
    let root: Bool

    let meta: NekoFolderMetadata?
    let envs: NekoEnvironment?
    let data: NekoData?

    let folders: [NekoFolderConfig]?
    let requests: [NekoRequestConfig]?
}

public struct NekoHttp: Codable {
    let url: String
    let method: String

    let body: String?
    let parameters: [String: String]?
    let headers: [String: String]?
}

public struct NekoRequestConfig: Codable {
    let meta: NekoRequestMetadata?
    let envs: NekoEnvironment?
    let data: NekoData?

    let request: NekoHttp
}

/// Neko Configuration Model
public typealias NekoConfig = NekoFolderConfig
