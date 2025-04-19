import Foundation
import Mustache
import SwiftyJSON

extension NekoCore {
    public struct NekoMustacheTemplate {
        public static func replaceVariables(_ string: String?, _ data: JSON)
            -> String
        {
            guard let string else { return "" }
            let template = try? Template(string: string)
            let value = try? template?.render(data.dictionaryObject)

            return value ?? ""
        }
    }
}
