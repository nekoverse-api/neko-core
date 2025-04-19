public class NativeExecutorPlugin: NekoExecutorPlugin {
    public func execute(_ request: NekoRequest) async throws -> NekoResponse {
        return try await NekoCore.AlamofireNekoNetwork.send(request)
    }
}

// TODO: Not Implemented Yet - Execute using gRPC proxy
public class GRPCExecutorPlugin: NekoExecutorPlugin {
    public func execute(_ request: NekoRequest) async throws -> NekoResponse {
        throw NekoError.NotImplementedYet
    }
}
