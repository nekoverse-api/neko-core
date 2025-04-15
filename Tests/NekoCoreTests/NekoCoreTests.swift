import Testing

@testable import NekoCore

public struct TestConfig: Decodable {
    let name: String
}

public struct TestNestedConfig: Decodable {
    let name: String
    let config: TestConfig
}

@Suite
class NekoFileLoaderSuite {
    @Test func testLoadJsonConfig() throws {
        let config = try NekoFileLoader.loadJson(
            TestConfig.self, fileName: "./Tests/Data/Loader/TestConfig.json")
        #expect("Gary Ascuy".isEqual(config.name))
    }

    @Test func testLoadNestedJsonConfig() throws {
        let config = try NekoFileLoader.loadJson(
            TestNestedConfig.self, fileName: "./Tests/Data/Loader/TestNestedConfig.json")
        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))

    }
}
