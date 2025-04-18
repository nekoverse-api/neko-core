public struct NativeExecutorPlugin: NekoExecutorPlugin {
    public func execute(_ request: NekoRequest) async throws -> NekoResponse {
        print("Gary Ascuy")
        throw NekoError.NotImplementedYet
    }
}

// TODO: Execute using gRPC
public struct GRPCExecutorPlugin: NekoExecutorPlugin {
    public func execute(_ request: NekoRequest) async throws -> NekoResponse {
        print("Gary Ascuy")
        throw NekoError.NotImplementedYet
    }
}
