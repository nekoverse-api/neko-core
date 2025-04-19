import Foundation
import Mustache
import SwiftyJSON

extension NekoCore {
    public struct NekoMustacheTemplate {
        public static func replaceVariables(_ string: String?, _ vars: JSON)
            -> String
        {
            guard let string else { return "" }
            let template = try? Template(string: string)
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
    }
}
