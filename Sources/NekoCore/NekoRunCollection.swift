import SwiftyJSON

extension NekoCore {
    public protocol NekoRunLifeCycle {
        // Request Events
        func onRequestBeforeAll(_ requestConfig: NekoRequestConfig, _ resolvedVars: JSON)

        func onRequestStarted(
            _ requestConfig: NekoRequestConfig, _ resolvedVars: JSON, _ index: Int)
        func onRequestProcessed(_ request: NekoRequest, _ index: Int)
        func onRequestCompleted(_ response: NekoResponse, _ index: Int)

        func onRequestTestingStarted(
            _ requestConfig: NekoRequestConfig, _ script: String, _ index: Int)
        func onRequestTestingCompleted(_ testResponse: NekoTestResponse, _ index: Int)

        func onRequestAfterAll(_ requestConfig: NekoRequestConfig)
        func onRequestError(_ error: Error)

        // Folder Events
        func onFolderBeforeAll(_ folderConfig: NekoFolderConfig, _ resolvedVars: JSON)

        func onFolderStarted(_ folderConfig: NekoFolderConfig, _ resolvedVars: JSON, _ index: Int)
        func onFolderBeforeFolderExecution(_ sortedFolders: [NekoFolderConfig], _ index: Int)
        func onFolderBeforeRequestExecution(_ sortedRequests: [NekoRequestConfig], _ index: Int)
        func onFolderCompleted(_ folderConfig: NekoFolderConfig, _ index: Int)

        func onFolderAfterAll(_ folderConfig: NekoFolderConfig)
        func onFolderError(_ error: Error)
    }

    public struct NekoRunCollection {
        public static func runCollection(
            _ config: NekoConfig, _ events: NekoRunLifeCycle?
        ) async throws {
            let defaultExecutor = NativeExecutorPlugin()
            let defaultTester = JavaScriptTesterPlugin()

            let vars = config.envs ?? JSON()
            try await runFolder(config, vars, defaultExecutor, defaultTester, events)
        }

        public static func runFolder(
            _ folderConfig: NekoFolderConfig,
            _ vars: JSON,
            _ defaultExecutor: NekoExecutorPlugin,
            _ defaultTester: NekoTesterPlugin,
            _ events: NekoRunLifeCycle?
        ) async throws {
            do {
                events?.onFolderBeforeAll(folderConfig, vars)
                let resolvedData = getResolvedDataOrDefault(folderConfig.data)

                for (index, data) in resolvedData.enumerated() {
                    let resolvedVars = try vars.merged(with: data)
                    events?.onFolderStarted(folderConfig, resolvedVars, index)

                    // Folders
                    if var folders = folderConfig.folders {
                        folders.sort { $0.meta?.seq ?? 0 > $1.meta?.seq ?? 0 }
                        events?.onFolderBeforeFolderExecution(folders, index)

                        for folder in folders {
                            let folderVars = folder.envs ?? JSON()
                            let resolvedVars = try resolvedVars.merged(with: folderVars)

                            let meta = folder.meta
                            let executor = getExecutorOrDefault(meta?.executor, defaultExecutor)
                            let tester = getTesterOrDefault(meta?.executor, defaultTester)

                            try await runFolder(folder, resolvedVars, executor, tester, events)
                        }
                    }

                    // Requests
                    if var requests = folderConfig.requests {
                        requests.sort { $0.meta?.seq ?? 0 > $1.meta?.seq ?? 0 }
                        events?.onFolderBeforeRequestExecution(requests, index)

                        for request: NekoRequestConfig in requests {
                            let requestVars = request.envs ?? JSON()
                            let resolvedVars = try resolvedVars.merged(with: requestVars)

                            let meta = request.meta
                            let executor = getExecutorOrDefault(meta?.executor, defaultExecutor)
                            let tester = getTesterOrDefault(meta?.executor, defaultTester)

                            try await runRequest(request, resolvedVars, executor, tester, events)
                        }
                    }

                    events?.onFolderCompleted(folderConfig, index)
                }

                events?.onFolderAfterAll(folderConfig)
            } catch {
                events?.onFolderError(error)
            }
        }

        public static func runRequest(
            _ requestConfig: NekoRequestConfig,
            _ vars: JSON,
            _ executor: NekoExecutorPlugin,
            _ tester: NekoTesterPlugin,
            _ events: NekoRunLifeCycle?
        ) async throws {
            do {
                events?.onRequestBeforeAll(requestConfig, vars)
                let resolvedData = getResolvedDataOrDefault(requestConfig.data)

                for (index, data) in resolvedData.enumerated() {
                    let resolvedVars = try vars.merged(with: data)

                    events?.onRequestStarted(requestConfig, resolvedVars, index)
                    let request = NekoMustacheTemplate.replaceRequestVariables(
                        requestConfig.http, resolvedVars)

                    events?.onRequestProcessed(request, index)

                    let response = try await executor.execute(request)
                    events?.onRequestCompleted(response, index)

                    if let postScript = getTestingScript(requestConfig.scripts?.postScript) {
                        var script = postScript
                        if requestConfig.scripts?.useVariables ?? false {
                            script = NekoMustacheTemplate.replaceVariables(postScript, resolvedVars)
                        }

                        events?.onRequestTestingStarted(requestConfig, script, index)
                        let testResponse = try await tester.test(script, response)
                        events?.onRequestTestingCompleted(testResponse, index)
                    }
                }

                events?.onRequestAfterAll(requestConfig)
            } catch {
                events?.onRequestError(error)
            }
        }
    }

    public static func getTestingScript(_ script: String?) -> String? {
        guard let script else { return nil }
        return script.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : script
    }

    public static func getExecutorOrDefault(
        _ plugin: NekoPlugin?, _ defaultExecutor: NekoExecutorPlugin
    ) -> NekoExecutorPlugin {
        guard let plugin else { return defaultExecutor }
        return Factory.getExecutor(plugin)
    }

    public static func getTesterOrDefault(
        _ plugin: NekoPlugin?, _ defaultExecutor: NekoTesterPlugin
    ) -> NekoTesterPlugin {
        guard let plugin else { return defaultExecutor }
        return Factory.getTester(plugin)
    }

    public static func getResolvedDataOrDefault(_ data: [JSON]?) -> [JSON] {
        guard let data else { return [JSON()] }
        return data.count == 0 ? [JSON()] : data
    }
}
