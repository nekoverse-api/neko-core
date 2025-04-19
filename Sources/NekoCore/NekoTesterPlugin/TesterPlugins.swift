//
// Plugin that executes JavaScipt script to validate response
//
public struct JavaScriptTesterPlugin: NekoTesterPlugin {
    public func test(_ script: String, _ response: NekoResponse) async throws -> NekoTestResponse {
        // TODO: Not implemented yet
        return NekoTestResponse(type: .Passed, asserts: [])
    }
}
