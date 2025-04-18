//
// Neko Pluggins
// Author: Gary Ascuy
// Version: 0.0.1 (neko@v0.0.1)
//
import Foundation
import Mustache
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

        for request in config.requests ?? [] {
            print("Request Execution".blue)

            let a = try! NekoFileLoader.NekoFile.asYaml(request.http)

            print(a)

            let req = try prepareRequest(request.http)
            print(try! NekoFileLoader.NekoFile.asYaml(req))
            await sendRequest(req)

            print("Completed execution".green)
        }

        // load
        // sort
        // folders
        // requests
        // execute
        // folders
        // requests

    }

    public static func sendRequest(_ http: NekoHttp) async {
        print("Sending request ...".red)
        guard var url = URL(string: http.url) else { return }

        if let parameters = http.parameters {
            let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            url.append(queryItems: queryItems)
        }

        var request = URLRequest(url: url)
        request.httpMethod = http.method
        request.httpBody = "{}".data(using: .utf8)
        // request.httpBody = http.body?.data(using: .utf8)

        if let headers = http.headers {
            headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        }

        print("Reuqest ready to send".red)

        let (data, response) = try! await URLSession.shared.data(for: request)

        print("REQUEST  ====> ".red)
        print("headers \(request.allHTTPHeaderFields)")
        print("length content \(request.httpBody?.count)")

        print("RESPONSE ====> ".red)

        print(response)
        print("RESPONSE ====> ".green)
        print(response.debugDescription)
        print(response.description)
        print("RESPONSE ====> ".green)
        print(response.expectedContentLength)
        print(response.suggestedFilename ?? "NO SUGGESTED NAME")
        print(response.mimeType ?? "NO MIME TYPE")
        print(response.textEncodingName ?? "NO ENCODING")
        print(response.url ?? "NO URL")

        print("RESPONSE ====> ".red)
        if let httpResponse = response as? HTTPURLResponse {
            print("statusCode: \(httpResponse.statusCode)")
            print("Headers \(httpResponse.allHeaderFields)")
            print("Headers \(httpResponse.expectedContentLength)")
            print("END ==============> ".red)

        }

        print("BODY ====> ".green)
        print(String(data: data, encoding: .utf8) ?? "WITHOUT DATA")
        // print("Response comes".green)
        // guard let data else { return }
        // guard let body = String(data: data, encoding: .utf8) else { return }
        // print("BODY ========== ")
        // print(body)
        // }
        // task.resume()
    }

    public static func prepareRequest(_ http: NekoHttp) throws -> NekoHttp {
        do {
            let data: [String: String] = [
                "baseUrl": "http://echo.nekoverse.me",
                "userId": "123122153234234324",
            ]

            return NekoHttp(
                url: updateVariables(http.url, data),
                method: updateVariables(http.method, data),
                body: updateVariables(http.body, data),
                parameters: updateDictionaryVariables(http.parameters, data),
                headers: updateDictionaryVariables(http.headers, data)
            )
        } catch {
            throw error
        }
    }

    public static func updateDictionaryVariables(
        _ values: [String: String]?, _ data: [String: String]
    )
        -> [String: String]
    {
        guard let values else { return [String: String]() }
        var resp: [String: String] = [:]
        for (key, value) in values {
            let newKey = updateVariables(key, data)
            let newValue = updateVariables(value, data)
            resp.updateValue(newValue, forKey: newKey)
        }

        return resp
    }

    // Update variables best try
    public static func updateVariables(_ string: String?, _ data: [String: String]) -> String {
        guard let string else { return "" }
        let template = try? Template(string: string)
        let value = try? template?.render(data)

        return value ?? ""
    }

    public static func executeFolder(_ folder: NekoFolderConfig) {
    }

    public static func executeRequest(_ request: NekoRequestConfig) {
    }
}
