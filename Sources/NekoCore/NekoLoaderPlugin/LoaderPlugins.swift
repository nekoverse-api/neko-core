//
// Plugin that loads JSON, JSONC, TOML, NEKO, YAML, YML, CSV files
//
public struct NekoFileLoaderPlugin: NekoLoaderPlugin {
    public func load(_ path: String) async throws -> NekoConfig {
        return try NekoFileLoader.load(NekoConfig.self, path)
    }
}

public struct NekoGitFriendlyLoaderPlugin: NekoLoaderPlugin {
    public func load(_ path: String) async throws -> NekoConfig {
        // TODO: Loads using folders partialy
        return try NekoFileLoader.load(NekoConfig.self, path)
    }
}

public struct NekoGRPCLoaderPlugin: NekoLoaderPlugin {
    public func load(_ path: String) async throws -> NekoConfig {
        // TODO: Loads from gRPC
        return try NekoFileLoader.load(NekoConfig.self, path)
    }
}
