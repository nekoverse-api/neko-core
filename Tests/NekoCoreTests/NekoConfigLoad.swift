import Testing

@testable import NekoCore

@Suite
class NekoConfigSuite {
    @Test func testLoadTomlConfig() throws {
        let fileName = "./Tests/Data/Config/Basic.neko.json"
        let config = try NekoFileLoader.loadJson(NekoConfig.self, fileName: fileName)

        #expect("neko@v1.0.0".isEqual(config.version))
    }
}
