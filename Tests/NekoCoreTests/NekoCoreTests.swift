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
class NekoFileJsonLoaderSuite {
    @Test func testLoadJsonConfig() throws {
        let config = try NekoFileLoader.loadJson(
            TestConfig.self, fileName: "./Tests/Data/Loader/Json/TestConfig.json")
        #expect("Gary Ascuy".isEqual(config.name))
    }

    @Test func testLoadNestedJsonConfig() throws {
        let config = try NekoFileLoader.loadJson(
            TestNestedConfig.self, fileName: "./Tests/Data/Loader/Json/TestNestedConfig.json")
        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }

    @Test func testLoadNestedJson5WithCommentsConfig() throws {
        let config = try NekoFileLoader.loadJson(
            TestNestedConfig.self, fileName: "./Tests/Data/Loader/Json/TestNestedConfig.jsonc")
        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }
}

@Suite
class NekoFileYamlLoaderSuite {
    @Test func testLoadYamlConfig() throws {
        let config = try NekoFileLoader.loadYaml(
            TestConfig.self, fileName: "./Tests/Data/Loader/Yaml/TestConfig.yml")
        #expect("Gary Ascuy".isEqual(config.name))
    }

    @Test func testLoadNestedYamlConfig() throws {
        let config = try NekoFileLoader.loadYaml(
            TestNestedConfig.self, fileName: "./Tests/Data/Loader/Yaml/TestNestedConfig.yml")
        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }

    @Test func testLoadNestedYamlWithCommentsConfig() throws {
        let config = try NekoFileLoader.loadYaml(
            TestNestedConfig.self, fileName: "./Tests/Data/Loader/Yaml/TestNestedConfig.yaml")
        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }
}
