import NekoCore

func getConfig(_ path: String, _ plugin: PluginOptions) async throws -> NekoConfig {
    do {
        let name = "\(plugin.loaderPlugin)"
        var properties = [String: String]()
        plugin.loaderProperties.forEach { properties[$0.key] = $0.value }

        let loader = NekoCore.Factory.getLoaderBy(name, properties)
        let config = try await loader.load(path)
        return config
    } catch {
        cli.error("Error trying load neko config")
        throw error
    }
}
