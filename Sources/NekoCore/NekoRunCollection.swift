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
        func onFolderStarted(_ folderConfig: NekoFolderConfig, _ resolvedVars: JSON)
        func onFolderBeforeFolderExecution(_ sortedFolders: [NekoFolderConfig])
        func onFolderBeforeRequestExecution(_ sortedRequests: [NekoRequestConfig])
        func onFolderCompleted(_ folderConfig: NekoFolderConfig)

        func onFolderError(_ error: Error)
    }

    public struct NekoRunCollection {
        public static func runCollection(
            _ config: NekoConfig, _ events: NekoRunLifeCycle?
        ) async throws {
            // Hardcoded Plugins
            let executor = NativeExecutorPlugin()
            let tester = JavaScriptTesterPlugin()

            let vars = config.envs ?? JSON()
            try await runFolder(config, vars, executor, tester, events)
        }

        public static func runFolder(
            _ folderConfig: NekoFolderConfig,
            _ vars: JSON,
            _ executor: NekoExecutorPlugin,
            _ tester: NekoTesterPlugin,
            _ events: NekoRunLifeCycle?
        ) async throws {
            do {
                events?.onFolderStarted(folderConfig, vars)

                if var folders = folderConfig.folders {
                    folders.sort { $0.meta?.seq ?? 0 > $1.meta?.seq ?? 0 }
                    events?.onFolderBeforeFolderExecution(folders)

                    for folder in folders {
                        let folderVars = folder.envs ?? JSON()
                        let resolvedVars = try vars.merged(with: folderVars)

                        try await runFolder(folder, resolvedVars, executor, tester, events)
                    }
                }

                if var requests = folderConfig.requests {
                    requests.sort { $0.meta?.seq ?? 0 > $1.meta?.seq ?? 0 }
                    events?.onFolderBeforeRequestExecution(requests)

                    for request in requests {
                        let requestVars = request.envs ?? JSON()
                        let resolvedVars = try vars.merged(with: requestVars)

                        try await runRequest(request, resolvedVars, executor, tester, events)
                    }
                }

                events?.onFolderCompleted(folderConfig)
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
                let resolvedData = requestConfig.data ?? [JSON()]

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
}
