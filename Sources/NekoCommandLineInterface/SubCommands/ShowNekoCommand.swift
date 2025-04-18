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

    @OptionGroup
    var plugin: PluginOptions

    @OptionGroup
    var general: GeneralOptions

    @Flag(name: .shortAndLong, help: "Shows requests summary, Default = False.")
    var showSummary: Bool = false

    @Option(name: .shortAndLong, help: "File format to export, Default = toml.")
    var outputFormat: Format = .toml

    @Argument
    var path: String

    func run() async throws {
        do {
            let params = buildExecutionParams(path: path, plugin: plugin, general: general)
            let config = try await NekoCore.getConfig(params)
            let string =
                switch outputFormat {
                case .json: try NekoFileLoader.NekoFile.asJson(config)
                case .yaml: try NekoFileLoader.NekoFile.asYaml(config)
                case .toml: try NekoFileLoader.NekoFile.asToml(config)
                }
            print(string)

        } catch {
            print("Unable to show config from \(path)".red)
            throw error
        }
    }
}
