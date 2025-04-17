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

    @Flag(name: .shortAndLong, help: "Shows requests summary.")
    var showSummary: Bool = false

    @Option(name: .shortAndLong, help: "File format to export.")
    var format: Format

    @Argument
    var path: String

    func run() async throws {
        print("show config \(path) with \(showSummary)")
    }
}
