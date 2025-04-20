import ArgumentParser
import Logging
import NekoCore
import Rainbow
import SwiftyJSON

struct RunNekoCommand: AsyncParsableCommand, NekoCore.NekoRunLifeCycle {
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
            cli.title("[猫][neko@v\(NekoCore.version)] Neko Collection: Starting Execution")
            let config = try await getConfig(path, plugin)
            try await NekoCore.NekoRunCollection.runCollection(config, self)
            cli.success("Completed successfully")
        } catch {
            cli.error("Error trying to execute collection: '\(path)'")
            throw error
        }
    }

    // Request Events
    public func onRequestStarted(_ requestConfig: NekoRequestConfig, _ resolvedVars: JSON) {
    }

    public func onRequestProcessed(_ request: NekoRequest) {
    }

    public func onRequestCompleted(_ response: NekoResponse) {
        print("")
        print("")

        switch response.status {
        case .success:
            print("SUCCESS RESPONSE".blue)
        case .failure(let error):
            cli.error("ERROR: \(error)")
        }

        print("")
        print(
            "StatusCode: (\( response.statusCode)) / Time: (\(response.metadata.timeInMs?[.TOTAL] ?? "0 ms"))"
                .green
        )

        if let time = response.metadata.time {
            cli.showTime(time)
        }

        print("")
        print("Body:".green)

        if let body = response.body {
            do {
                let json = JSON(parseJSON: body)
                let yaml = try NekoFileLoader.NekoFile.asYaml(json)
                print(yaml)
            } catch {
                print(body)
            }
        }
    }

    public func onRequestTestingStarted(_ requestConfig: NekoRequestConfig, _ script: String) {
    }

    public func onRequestTestingCompleted(_ testResponse: NekoTestResponse) {
    }

    public func onRequestError(_ error: Error) {
        cli.error("Unable to perform a request")
    }

    // Folder Events
    public func onFolderStarted(_ folderConfig: NekoFolderConfig, _ resolvedVars: JSON) {
    }

    public func onFolderBeforeFolderExecution(_ sortedFolders: [NekoFolderConfig]) {
    }

    public func onFolderBeforeRequestExecution(_ sortedRequests: [NekoRequestConfig]) {
    }

    public func onFolderCompleted(_ folderConfig: NekoFolderConfig) {
    }

    public func onFolderError(_ error: Error) {
    }
}
