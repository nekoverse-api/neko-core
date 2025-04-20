import ArgumentParser
import Logging
import NekoCore
import Rainbow

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
    public func onRequestStarted(_ requestConfig: NekoRequestConfig) {
    }

    public func onRequestProcessed(_ request: NekoRequest) {
    }

    public func onRequestCompleted(_ response: NekoResponse) {
        print("")
        // cli.title("REQUEST COMPLETED")
        switch response.status {
        case .success:
            cli.success("It works")
        case .failure(let error):
            cli.error("Error: \(error)")
        }

        print(
            "StatusCode: (\( response.statusCode)) / Time: (\(response.metadata.timeInMs?[.TOTAL] ?? "0 ms"))"
                .green
        )

        if let time = response.metadata.timeInMs {
            print("SocketInitialization:\t\(time[.SocketInitialization] ?? "0 ms")")
            print("DnsLookup:\t\t\(time[.DnsLookup] ?? "0 ms")")
            print("TCPHandshake:\t\t\(time[.TCPHandshake] ?? "0 ms")")
            print("SSLHandshake:\t\t\(time[.SSLHandshake] ?? "0 ms")")
            print("WaitingTTFB:\t\t\(time[.WaitingTimeToFirstByte] ?? "0 ms")")
            print("Download:\t\t\(time[.Download] ?? "0 ms")")
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
    public func onFolderStarted(_ folderConfig: NekoFolderConfig) {
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
