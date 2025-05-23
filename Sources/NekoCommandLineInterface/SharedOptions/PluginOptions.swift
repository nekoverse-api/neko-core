import ArgumentParser

enum Loader: String, ExpressibleByArgument, CaseIterable {
    case File
    case GitFriendly
    case gRPC
}

enum Executor: String, ExpressibleByArgument, CaseIterable {
    case Native
    case gRPC
}

enum Tester: String, ExpressibleByArgument, CaseIterable {
    case Native
    case gRPC
}

struct PluginProperty: Codable {
    var key: String
    var value: String

    init(_ string: String) throws {
        let values = string.components(separatedBy: "=")
            .filter { !$0.isEmpty }
        let key = values.count >= 1 ? values[0] : "unknown"
        let value = values.count >= 2 ? values[1] : ""
        self.init(key, value)
    }

    init(_ key: String, _ value: String) {
        self.key = key
        self.value = value
    }
}

struct PluginOptions: ParsableArguments {
    @Option(name: .shortAndLong, help: "Loader plugin name")
    var loaderPlugin: Loader = .File

    @Option(help: "Loader plugin properties.", transform: PluginProperty.init)
    var loaderProperties: [PluginProperty] = []
}
