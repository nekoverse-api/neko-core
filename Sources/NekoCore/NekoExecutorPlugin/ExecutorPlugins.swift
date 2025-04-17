public struct NativeNekoExecutorPlugin: NekoExecutorPlugin {
    public func execute(_ request: NekoRequest) async throws -> NekoResponse {
        throw NekoError.NotImplementedYet
    }
}
