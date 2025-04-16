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
        let path = "./Tests/Data/Loader/Json/TestConfig.json"
        let config = try NekoFileLoader.loadJson(TestConfig.self, fileName: path)

        #expect("Gary Ascuy".isEqual(config.name))
    }

    @Test func testLoadNestedJsonConfig() throws {
        let path = "./Tests/Data/Loader/Json/TestNestedConfig.json"
        let config = try NekoFileLoader.loadJson(TestNestedConfig.self, fileName: path)

        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }

    @Test func testLoadNestedJson5WithCommentsConfig() throws {
        let path = "./Tests/Data/Loader/Json/TestNestedConfig.jsonc"
        let config = try NekoFileLoader.loadJson(TestNestedConfig.self, fileName: path)

        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }
}

@Suite
class NekoFileYamlLoaderSuite {
    @Test func testLoadYamlConfig() throws {
        let path = "./Tests/Data/Loader/Yaml/TestConfig.yml"
        let config = try NekoFileLoader.loadYaml(TestConfig.self, fileName: path)

        #expect("Gary Ascuy".isEqual(config.name))
    }

    @Test func testLoadNestedYamlConfig() throws {
        let path = "./Tests/Data/Loader/Yaml/TestNestedConfig.yml"
        let config = try NekoFileLoader.loadYaml(TestNestedConfig.self, fileName: path)

        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }

    @Test func testLoadNestedYamlWithCommentsConfig() throws {
        let path = "./Tests/Data/Loader/Yaml/TestNestedConfig.yaml"
        let config = try NekoFileLoader.loadYaml(TestNestedConfig.self, fileName: path)

        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }
}

@Suite
class NekoFileTomlLoaderSuite {
    @Test func testLoadTomlConfig() throws {
        let path = "./Tests/Data/Loader/Toml/TestConfig.toml"
        let config = try NekoFileLoader.loadToml(TestConfig.self, fileName: path)

        #expect("Gary Ascuy".isEqual(config.name))
    }

    @Test func testLoadNestedTomlWithCommentsConfig() throws {
        let path = "./Tests/Data/Loader/Toml/TestNestedConfig.toml"
        let config = try NekoFileLoader.loadToml(TestNestedConfig.self, fileName: path)

        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }
}
