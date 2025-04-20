import SwiftyJSON

public struct NekoPlugin: Codable {
    public var name: String?
    public var properties: [String: String]
}

public struct NekoFolderMetadata: Codable {
    public var name: String?
    public var description: String?
    public var seq: Int64?
    public var authors: [String]?

    public var loader: NekoPlugin?
    public var executor: NekoPlugin?
    public var tester: NekoPlugin?
}

public struct NekoRequestMetadata: Codable {
    public var version: String?
    public var authors: [String]?

    public var name: String?
    public var description: String?
    public var seq: Int64?

    public var loader: NekoPlugin?
    public var executor: NekoPlugin?
    public var tester: NekoPlugin?
}

public typealias NekoData = [JSON]
public typealias NekoEnvironment = JSON

public struct NekoFolderConfig: Codable {
    public var version: String?
    public var root: Bool?

    public var meta: NekoFolderMetadata?
    public var envs: NekoEnvironment?
    public var data: NekoData?

    public var folders: [NekoFolderConfig]?
    public var requests: [NekoRequestConfig]?
}

public struct NekoHttp: Codable {
    public var url: String
    public var method: String

    public var body: String?
    public var parameters: [String: String]?
    public var headers: [String: String]?
}

public struct NekoTestScripts: Codable {
    public var useVariables: Bool = true

    public var preScript: String?
    public var postScript: String?
}

public struct NekoRequestConfig: Codable {
    public var meta: NekoRequestMetadata?
    public var envs: NekoEnvironment?
    public var data: NekoData?

    public var http: NekoHttp
    public var scripts: NekoTestScripts?
}

/// Neko Configuration Model
public typealias NekoConfig = NekoFolderConfig
