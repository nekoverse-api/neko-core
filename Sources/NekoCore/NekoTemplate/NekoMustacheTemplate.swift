import Foundation
import Mustache
import SwiftyJSON

extension NekoCore {
    public struct NekoMustacheTemplate {
        public static func getConfiguration() -> Configuration {
            var configuration = Configuration()
            configuration.contentType = .text
            return configuration
        }

        public static func replaceVariables(_ string: String?, _ vars: JSON)
            -> String
        {
            guard let string else { return "" }
            let template = try? Template(string: string, configuration: getConfiguration())
            let value = try? template?.render(vars.dictionaryObject)

            return value ?? ""
        }

        public static func replaceDictionaryVariables(_ values: [String: String]?, _ vars: JSON)
            -> [String: String]
        {
            var resp: [String: String] = [:]
            guard let values else { return resp }

            for (key, value) in values {
                let newKey = replaceVariables(key, vars)
                let newValue = replaceVariables(value, vars)

                if !newKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    resp.updateValue(newValue, forKey: newKey)
                }
            }

            return resp
        }

        public static func replaceRequestVariables(_ http: NekoHttp, _ vars: JSON) -> NekoRequest {
            return NekoRequest(
                url: replaceVariables(http.url, vars),
                method: replaceVariables(http.method, vars),
                parameters: replaceDictionaryVariables(http.parameters, vars),
                headers: replaceDictionaryVariables(http.headers, vars),
                body: replaceVariables(http.body, vars)
            )
        }
    }
}
