//
// Neko Pluggins
// Author: Gary Ascuy
// Version: 0.0.1 (neko@v0.0.1)
//
import Foundation
import Rainbow

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

    public static func getConfig(_ params: ExecuteParams) async throws -> NekoConfig {
        do {
            let loader = NekoCore.Factory.getLoader(params.loader)
            let value = try await loader.load(params.path)
            return value
        } catch {
            throw error
        }
    }

    public static func execute(_ params: ExecuteParams) async throws {
        print("NekoCore Execute".green)

        let loader = NekoCore.Factory.getLoader(params.loader)
        let config = try await loader.load(params.path)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let json = try? encoder.encode(config)
        print("JSON".blue.bold)
        print(String(data: json!, encoding: .utf8)!)

        let executor = NekoCore.Factory.getExecutor(params.executor)
        // executor.execute(NekoRequest)

        // load
        // sort
        // folders
        // requests
        // execute
        // folders
        // requests

    }

    public static func executeFolder(_ folder: NekoFolderConfig) {
    }

    public static func executeRequest(_ request: NekoRequestConfig) {

    }
}
