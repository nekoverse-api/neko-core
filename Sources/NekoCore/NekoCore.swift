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
