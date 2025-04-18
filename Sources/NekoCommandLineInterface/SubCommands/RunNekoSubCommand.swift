import ArgumentParser
import Logging
import NekoCore
import Rainbow

struct RunNekoCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "run",
        abstract: "Runs Neko Project."
    )

    @OptionGroup
    var plugin: PluginOptions

    @OptionGroup
    var general: GeneralOptions

    @Argument
    var path: String

    func run() async throws {
        do {
            print("Starting execution".blue)
            let params = buildExecutionParams(path: path, plugin: plugin, general: general)
            try await NekoCore.execute(params)
            print("Completed successfully".green)
        } catch {
            throw error
        }
    }
}
