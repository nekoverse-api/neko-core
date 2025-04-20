extension NekoCore {
    public struct LoaderFactoryUtils: GRPCFactoryUtils {
        static let NATIVE_PLUGIN_NAMES = lowercased(["Native", "NativePlugin"])
        static let GIT_FRIENDLY_PLUGIN_NAMES = lowercased(["GitFriendly", "GitFriendlyPlugin"])

        public static func isNative(_ plugin: NekoPlugin) -> Bool {
            guard let name = plugin.name else { return false }
            return LoaderFactoryUtils.NATIVE_PLUGIN_NAMES.contains(name.lowercased())
        }

        public static func isGitFriendly(_ plugin: NekoPlugin) -> Bool {
            guard let name = plugin.name else { return false }
            return LoaderFactoryUtils.GIT_FRIENDLY_PLUGIN_NAMES.contains(name.lowercased())
        }
    }

    public struct ExecutorFactoryUtils: GRPCFactoryUtils {
        static let NATIVE_PLUGIN_NAMES = lowercased(["Native", "NativePlugin"])

        public static func isNative(_ plugin: NekoPlugin) -> Bool {
            guard let name = plugin.name else { return false }
            return ExecutorFactoryUtils.NATIVE_PLUGIN_NAMES.contains(name.lowercased())
        }
    }

    public struct TesterFactoryUtils: GRPCFactoryUtils {
        static let JAVASCRIPT_PLUGIN_NAMES = lowercased(["JavaScript", "JavaScriptPlugin"])

        public static func isJavaScript(_ plugin: NekoPlugin) -> Bool {
            guard let name = plugin.name else { return false }
            return TesterFactoryUtils.JAVASCRIPT_PLUGIN_NAMES.contains(name.lowercased())
        }
    }

    public struct Factory {
        public static func getLoaderBy(_ name: String, _ properties: [String: String])
            -> NekoLoaderPlugin
        {
            return getLoader(NekoPlugin(name: name, properties: properties))
        }

        public static func getExecutorBy(_ name: String, _ properties: [String: String])
            -> NekoExecutorPlugin
        {
            return getExecutor(NekoPlugin(name: name, properties: properties))
        }

        public static func getTesterBy(_ name: String, _ properties: [String: String])
            -> NekoTesterPlugin
        {
            return getTester(NekoPlugin(name: name, properties: properties))
        }

        static func getLoader(_ plugin: NekoPlugin) -> NekoLoaderPlugin {
            if LoaderFactoryUtils.isNative(plugin) {
                return NativeLoaderPlugin()
            }

            if LoaderFactoryUtils.isGitFriendly(plugin) {
                return GitFriendlyLoaderPlugin()
            }

            if LoaderFactoryUtils.isGRPC(plugin) {
                return GRPCLoaderPlugin()
            }

            return NativeLoaderPlugin()
        }

        static func getExecutor(_ plugin: NekoPlugin) -> NekoExecutorPlugin {
            if ExecutorFactoryUtils.isNative(plugin) {
                return NativeExecutorPlugin()
            }

            if ExecutorFactoryUtils.isGRPC(plugin) {
                return GRPCExecutorPlugin()
            }

            return NativeExecutorPlugin()
        }

        static func getTester(_ plugin: NekoPlugin) -> NekoTesterPlugin {
            if TesterFactoryUtils.isJavaScript(plugin) {
                return JavaScriptTesterPlugin()
            }

            if TesterFactoryUtils.isGRPC(plugin) {
                return GRPCTesterPlugin()
            }

            return JavaScriptTesterPlugin()
        }
    }
}

func lowercased(_ values: [String]) -> [String] {
    return values.map { $0.lowercased() }
}

protocol GRPCFactoryUtils {}

extension GRPCFactoryUtils {
    public static func isGRPC(_ plugin: NekoPlugin) -> Bool {
        let GRPC_PLUGIN_NAMES = lowercased(["gRPC", "gRPCPlugin"])

        guard let name = plugin.name else { return false }
        return GRPC_PLUGIN_NAMES.contains(name.lowercased())
    }
}
