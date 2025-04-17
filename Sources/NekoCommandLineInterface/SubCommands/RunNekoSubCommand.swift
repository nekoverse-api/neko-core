import ArgumentParser
import NekoCore

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
        print("Starting execution")

        do {
            let params = getParams()
            try await NekoCore.execute(params)
            print("Completed successfully")
        } catch {
            throw error
        }
    }

    func getParams() -> NekoCore.ExecuteParams {
        var params = NekoCore.ExecuteParams(path)

        params.loader.name = plugin.loaderPlugin.rawValue
        for property in plugin.loaderProperties {
            params.loader.properties.updateValue(property.value, forKey: property.key)
        }

        params.executor.name = plugin.executorPlugin.rawValue
        for property in plugin.executorProperties {
            params.executor.properties.updateValue(property.value, forKey: property.key)
        }

        params.tester.name = plugin.testerPlugin.rawValue
        for property in plugin.testerProperties {
            params.tester.properties.updateValue(property.value, forKey: property.key)
        }

        params.verbose = general.verbose
        return params
    }
}
