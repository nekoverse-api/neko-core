import ArgumentParser
import Logging
import NekoCore
import Rainbow

struct RunNekoCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "run",
        abstract: "Runs Neko Project."
    )

    @Flag(help: "Execute all without performing the requests (for debugging).")
    var dirtyRun: Bool = false

    @OptionGroup
    var plugin: PluginOptions

    @OptionGroup
    var general: GeneralOptions

    @Argument(help: "Neko colleciton file.")
    var path: String

    func run() async throws {
        do {
            cli.title("Starting Neko Collection Execution")
            let params = buildExecutionParams(path: path, plugin: plugin, general: general)
            try await NekoCore.runNekoCollection(params)
            cli.success("Completed successfully")
        } catch {
            cli.error("Error trying to execute collection")
            throw error
        }
    }
}
