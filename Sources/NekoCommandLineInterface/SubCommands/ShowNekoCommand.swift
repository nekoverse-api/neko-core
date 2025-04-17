import ArgumentParser

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
        print("show config \(path) with \(showSummary) and \(plugin.loaderProperties)")
    }
}
