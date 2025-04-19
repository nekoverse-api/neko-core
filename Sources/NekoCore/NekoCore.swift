//
// Neko Pluggins
// Author: Gary Ascuy
// Version: 0.0.1 (neko@v0.0.1)
//

import Alamofire
import Foundation
import Mustache
import Rainbow
import SwiftyJSON

//
// NekoLoaderPlugin is used to load configuration
//
public protocol NekoLoaderPlugin {
    func load(_ path: String) async throws -> NekoConfig
}

//
// NekoExecutorPlugin is used to execute request
//
public protocol NekoExecutorPlugin {
    func execute(_ request: NekoRequest) async throws -> NekoResponse
}

//
// NekoTesterPlugin is used to test requests
//
public protocol NekoTesterPlugin {
    func test(_ script: String, _ response: NekoResponse) async throws -> NekoTestResponse
}

public struct NekoCore {
    public static let version = "0.0.1"
    public init() {}
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

    public static func runNekoCollection(_ params: ExecuteParams) async throws {
        print("NekoCore Execute".green)

        let loader = NekoCore.Factory.getLoader(params.loader)
        let config = try await loader.load(params.path)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let json = try? encoder.encode(config)
        print("JSON".blue.bold)
        print(String(data: json!, encoding: .utf8)!)

        let executor = NekoCore.Factory.getExecutor(params.executor)
        for request in config.requests ?? [] {
            print("Request Execution".blue)

            let a = try! NekoFileLoader.NekoFile.asYaml(request.http)

            print(a)

            let vars = [
                "baseUrl": "https://echo.nekoverse.me",
                "userId": "123122153234234324",
            ]

            let request = NekoMustacheTemplate.replaceRequestVariables(
                request.http, JSON(vars))
            print(try! NekoFileLoader.NekoFile.asYaml(request))

            let response = try await executor.execute(request)
            print("SUCCCESS RESPONSE BODY".green)

            print(try NekoFileLoader.NekoFile.asYaml(response))
        }

        // load
        // sort
        // folders
        // requests
        // execute
        // folders
        // requests
    }
}
