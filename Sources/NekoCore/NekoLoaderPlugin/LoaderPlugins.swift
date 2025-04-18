//
// Plugin that loads JSON, JSONC, TOML, NEKO, YAML, YML, CSV files
//
public struct NativeLoaderPlugin: NekoLoaderPlugin {
    public func load(_ path: String) async throws -> NekoConfig {
        return try NekoFileLoader.load(NekoConfig.self, path)
    }
}

// TODO: Loads using folders partialy
public struct GitFriendlyLoaderPlugin: NekoLoaderPlugin {
    public func load(_ path: String) async throws -> NekoConfig {
        return try NekoFileLoader.load(NekoConfig.self, path)
    }
}

// TODO: Loads from gRPC
public struct GRPCLoaderPlugin: NekoLoaderPlugin {
    public func load(_ path: String) async throws -> NekoConfig {
        return try NekoFileLoader.load(NekoConfig.self, path)
    }
}
