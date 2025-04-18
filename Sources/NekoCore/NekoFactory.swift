extension NekoCore {
    static func lowercased(_ values: [String]) -> [String] {
        return values.map { $0.lowercased() }
    }

    public struct LoaderFactoryUtils {
        static let NATIVE_PLUGIN_NAMES = lowercased(["Native", "NativePlugin"])
        static let GIT_FRIENDLY_PLUGIN_NAMES = lowercased(["GitFriendly", "GitFriendlyPlugin"])
        static let GRPC_PLUGIN_NAMES = lowercased(["RGPC", "RGPCPlugin"])

        public static func isNative(_ plugin: NekoPlugin) -> Bool {

            guard let name = plugin.name else { return false }
            return LoaderFactoryUtils.NATIVE_PLUGIN_NAMES.contains(name.lowercased())
        }

        public static func isGitFriendly(_ plugin: NekoPlugin) -> Bool {
            guard let name = plugin.name else { return false }
            return LoaderFactoryUtils.GIT_FRIENDLY_PLUGIN_NAMES.contains(name.lowercased())
        }

        public static func isGRPC(_ plugin: NekoPlugin) -> Bool {

            guard let name = plugin.name else { return false }
            return LoaderFactoryUtils.GRPC_PLUGIN_NAMES.contains(name.lowercased())
        }
    }

    public struct ExecutorFactoryUtils {
        static let NATIVE_PLUGIN_NAMES = lowercased(["Native", "NativePlugin"])
        static let GRPC_PLUGIN_NAMES = lowercased(["RGPC", "RGPCPlugin"])

        public static func isNative(_ plugin: NekoPlugin) -> Bool {
            guard let name = plugin.name else { return false }
            return LoaderFactoryUtils.NATIVE_PLUGIN_NAMES.contains(name.lowercased())
        }

        public static func isGRPC(_ plugin: NekoPlugin) -> Bool {
            guard let name = plugin.name else { return false }
            return LoaderFactoryUtils.GRPC_PLUGIN_NAMES.contains(name.lowercased())
        }
    }

    public struct Factory {
        public static func getLoader(_ plugin: NekoPlugin) -> NekoLoaderPlugin {
            if LoaderFactoryUtils.isNative(plugin) {
                print("Using Native Loader Plugin")
                return NativeLoaderPlugin()
            }

            if LoaderFactoryUtils.isGitFriendly(plugin) {
                print("Using GitFriendly Loader Plugin")
                return GitFriendlyLoaderPlugin()
            }

            if LoaderFactoryUtils.isGRPC(plugin) {
                print("Using gRPC Loader Plugin")
                return GRPCLoaderPlugin()
            }

            print("Using Native Loader Plugin as default")
            return NativeLoaderPlugin()
        }

        public static func getExecutor(_ plugin: NekoPlugin) -> NekoExecutorPlugin {
            if ExecutorFactoryUtils.isNative(plugin) {
                print("Using Native Executor Plugin")
                return NativeExecutorPlugin()
            }

            if ExecutorFactoryUtils.isGRPC(plugin) {
                print("Using gRPC Executor Plugin")
                return GRPCExecutorPlugin()
            }

            print("Using Native Executor Plugin as default")
            return NativeExecutorPlugin()
        }
    }
}
