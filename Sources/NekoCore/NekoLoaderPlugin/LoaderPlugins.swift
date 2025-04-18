//
// Plugin that loads JSON, JSONC, TOML, NEKO, YAML, YML, CSV files
//
public class NativeLoaderPlugin: NekoLoaderPlugin {
    public func load(_ path: String) async throws -> NekoConfig {
        return try NekoFileLoader.load(NekoConfig.self, path)
    }
}

// TODO: Loads using folders partialy
public class GitFriendlyLoaderPlugin: NekoLoaderPlugin {
    public func load(_ path: String) async throws -> NekoConfig {
        return try NekoFileLoader.load(NekoConfig.self, path)
    }
}

// TODO: Loads from gRPC
public class GRPCLoaderPlugin: NekoLoaderPlugin {
    public func load(_ path: String) async throws -> NekoConfig {
        return try NekoFileLoader.load(NekoConfig.self, path)
    }
}
