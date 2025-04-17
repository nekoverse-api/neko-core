public struct NativeNekoExecutorPlugin: NekoExecutorPlugin {
    public func execute(_ request: NekoRequest) async throws -> NekoResponse {
        print("Gary Ascuy")
        throw NekoError.NotImplementedYet
    }
}
