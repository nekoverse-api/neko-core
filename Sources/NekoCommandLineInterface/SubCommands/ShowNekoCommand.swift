import ArgumentParser
import NekoCore

enum Format: String, ExpressibleByArgument, CaseIterable {
    case json
    case toml
    case yaml
}

struct ShowNekoCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "show",
        abstract: "Shows Neko Project Config."
    )

    @Option(name: .shortAndLong, help: "File format to export.")
    var outputFormat: Format = .yaml

    @OptionGroup
    var plugin: PluginOptions

    @OptionGroup
    var general: GeneralOptions

    @Argument
    var path: String

    func run() async throws {
        do {
            let config = try await getConfig(path, plugin)
            let string =
                switch outputFormat {
                case .json: try NekoFileLoader.NekoFile.asJson(config)
                case .yaml: try NekoFileLoader.NekoFile.asYaml(config)
                case .toml: try NekoFileLoader.NekoFile.asToml(config)
                }
            print(string)
        } catch {
            cli.error("Error trying to show collection: '\(path)'")
            throw error
        }
    }
}
