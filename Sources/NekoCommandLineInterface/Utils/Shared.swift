import NekoCore

func buildExecutionParams(path: String, plugin: PluginOptions, general: GeneralOptions)
    -> NekoCore.ExecuteParams
{
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
