import Testing

@testable import NekoCore

public struct TestConfig: Decodable {
    let name: String
}

public struct TestNestedConfig: Decodable {
    let name: String
    let config: TestConfig
}

public struct TestCsvNestedConfig: Decodable {
    let value: String
    let config: TestConfig
}

@Suite
class NekoFileJsonLoaderSuite {
    @Test func testLoadJsonConfig() throws {
        let path = "./Tests/Data/Loader/Json/TestConfig.json"
        let config = try NekoFileLoader.NekoFile.loadJson(TestConfig.self, path)

        #expect("Gary Ascuy".isEqual(config.name))
    }

    @Test func testLoadNestedJsonConfig() throws {
        let path = "./Tests/Data/Loader/Json/TestNestedConfig.json"
        let config = try NekoFileLoader.NekoFile.loadJson(TestNestedConfig.self, path)

        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }

    @Test func testLoadNestedJson5WithCommentsConfig() throws {
        let path = "./Tests/Data/Loader/Json/TestNestedConfig.jsonc"
        let config = try NekoFileLoader.NekoFile.loadJson(TestNestedConfig.self, path)

        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }
}

@Suite
class NekoFileYamlLoaderSuite {
    @Test func testLoadYamlConfig() throws {
        let path = "./Tests/Data/Loader/Yaml/TestConfig.yml"
        let config = try NekoFileLoader.NekoFile.loadYaml(TestConfig.self, path)

        #expect("Gary Ascuy".isEqual(config.name))
    }

    @Test func testLoadNestedYamlConfig() throws {
        let path = "./Tests/Data/Loader/Yaml/TestNestedConfig.yml"
        let config = try NekoFileLoader.NekoFile.loadYaml(TestNestedConfig.self, path)

        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }

    @Test func testLoadNestedYamlWithCommentsConfig() throws {
        let path = "./Tests/Data/Loader/Yaml/TestNestedConfig.yaml"
        let config = try NekoFileLoader.NekoFile.loadYaml(TestNestedConfig.self, path)

        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }
}

@Suite
class NekoFileTomlLoaderSuite {
    @Test func testLoadTomlConfig() throws {
        let path = "./Tests/Data/Loader/Toml/TestConfig.toml"
        let config = try NekoFileLoader.NekoFile.loadToml(TestConfig.self, path)

        #expect("Gary Ascuy".isEqual(config.name))
    }

    @Test func testLoadNestedTomlWithCommentsConfig() throws {
        let path = "./Tests/Data/Loader/Toml/TestNestedConfig.toml"
        let config = try NekoFileLoader.NekoFile.loadToml(TestNestedConfig.self, path)

        #expect("Gary Ascuy".isEqual(config.name))
        #expect("Nested Gary Ascuy".isEqual(config.config.name))
    }
}

@Suite
class NekoFileCsvLoaderSuite {
    @Test func testLoadCsvConfig() throws {
        let path = "./Tests/Data/Loader/Csv/TestConfig.csv"
        let configs = try NekoFileLoader.NekoFile.loadCsv(TestConfig.self, path)

        #expect(configs.count == 2)
        #expect("Gary Ascuy".isEqual(configs[0].name))
        #expect("Gory Ascuy".isEqual(configs[1].name))
    }

    // TODO: Update library or reader to support nested objects without trick
    @Test func testLoadNestedCsvConfig() throws {
        let path = "./Tests/Data/Loader/Csv/TestNestedConfig.csv"
        let configs = try NekoFileLoader.NekoFile.loadCsv(TestCsvNestedConfig.self, path)

        #expect(configs.count == 2)
        #expect("Gary Ascuy".isEqual(configs[0].value))
        #expect("Nested Gary Ascuy".isEqual(configs[0].config.name))
    }
}
