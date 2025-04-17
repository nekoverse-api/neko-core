//
// Neko Pluggins
// Author: Gary Ascuy
// Version: 0.0.1 (neko@v0.0.1)
//
import os

//
// NekoLoaderPlugin is used to load configuration
//
public protocol NekoLoaderPlugin {
    func load(_ path: String) async throws -> NekoConfig
}

//
// NekoExecutorPlugin is used to execute a request
//
public protocol NekoExecutorPlugin {
    func execute(_ request: NekoRequest) async throws -> NekoResponse
}

public struct NekoCore {
    public static let version = "0.0.1"
}

extension NekoCore {
    public struct ExecuteParams {
        public var path: String

        public init(_ path: String) {
            self.path = path
        }

        public var loader: NekoPlugin = NekoPlugin(name: "", properties: [String: String]())
        public var executor: NekoPlugin = NekoPlugin(name: "", properties: [String: String]())
        public var tester: NekoPlugin = NekoPlugin(name: "", properties: [String: String]())

        public var verbose: Bool = false
    }

    public static func execute(_ params: ExecuteParams) async throws {
        print("NekoCore Execute")
    }
}
