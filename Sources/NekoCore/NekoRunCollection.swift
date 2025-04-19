import SwiftyJSON

extension NekoCore {
    public protocol NekoRunLifeCycle {
        func onRequestStarted(_ meta: NekoRequestConfig)
        func onRequestProcessed(_ request: NekoRequest)
        func onRequestCompleted(_ response: NekoResponse)

        func onRequestTestingStarted()
        func onRequestTestingCompleted(_ testResponse: NekoTestResponse)

        func onRequestError(_ error: Error)
    }

    public struct NekoRunCollection {

        public static func runCollection(
            _ config: NekoConfig, _ events: NekoRunLifeCycle?
        ) async throws {
            // config.

        }

        public static func runFolder(
            _ folderConfig: NekoFolderConfig,
            _ vars: JSON,
            _ executor: NekoExecutorPlugin,
            _ tester: NekoTesterPlugin,
            _ events: NekoRunLifeCycle?
        ) {

        }

        // TODO: Support Data (ForEach)
        public static func runRequest(
            _ requestConfig: NekoRequestConfig,
            _ vars: JSON,
            _ executor: NekoExecutorPlugin,
            _ tester: NekoTesterPlugin,
            _ events: NekoRunLifeCycle?
        ) async throws {
            do {
                events?.onRequestStarted(requestConfig)
                let request = NekoMustacheTemplate.replaceRequestVariables(requestConfig.http, vars)
                events?.onRequestProcessed(request)
                let response = try await executor.execute(request)
                events?.onRequestCompleted(response)

                events?.onRequestTestingStarted()
                let testResponse = try await tester.test("", response)
                events?.onRequestTestingCompleted(testResponse)
            } catch {
                events?.onRequestError(error)
            }
        }
    }
}
