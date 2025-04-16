//
// Neko Pluggins (Loader)
//
public protocol NekoLoaderPlugin {
    func load<T>(_ type: T.Type, fileName: String) async throws -> T where T: Decodable
}

//
// Plugin that loads JSON, JSONC, TOML, NEKO, YAML, YML, CSV files
//
public struct NekoFileLoaderPlugin: NekoLoaderPlugin {
    public func load<T>(_ type: T.Type, fileName: String) async throws -> T
    where T: Decodable {
        return try NekoFileLoader.load(type, fileName: fileName)
    }
}

public struct NekoGitFriendlyLoaderPlugin: NekoLoaderPlugin {
    public func load<T>(_ type: T.Type, fileName: String) async throws -> T
    where T: Decodable {
        // TODO: Loads using folders partialy
        return try NekoFileLoader.load(type, fileName: fileName)
    }
}

public struct NekoGRPCLoaderPlugin: NekoLoaderPlugin {
    public func load<T>(_ type: T.Type, fileName: String) async throws -> T
    where T: Decodable {
        // TODO: Loads from gRPC
        return try NekoFileLoader.load(type, fileName: fileName)
    }
}
