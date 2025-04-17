import Testing

@testable import NekoCore

typealias Utils = NekoFileLoader.Utils
typealias NekoFile = NekoFileLoader.NekoFile

@Suite
struct NekoConfigUtilsSuite {
    @Test(
        arguments: zip(
            [
                "./Tests/Data/Config/Basic/Basic.neko.json",
                "./Tests/Data/Config/Basic/Basic.neko.JSON",
                "./Tests/Data/Config/Basic/Basic.neko.JsoN",
                "./Tests/Data/Config/Basic/Basic.neko.toml",
                "./Tests/Data/Config/Basic/Basic.neko.TOML",
                "./Tests/Data/Config/Basic/Basic.neko.TomL",
                "./Tests/Data/Config/Basic/Basic.neko",
                "./Tests/Data/Config/Basic/Basic.neko.yaml",
                "./Tests/Data/Config/Basic/Basic.neko.YAML",
                "./Tests/Data/Config/Basic/Basic.neko.YamL",
                "./Tests/Data/Config/Basic/Basic.neko.CSV",
            ],
            [
                "json",
                "json",
                "json",
                "toml",
                "toml",
                "toml",
                "neko",
                "yaml",
                "yaml",
                "yaml",
                "csv",
            ]
        )
    )
    func testLoadBasicTomlConfig(path: String, expectedPathExtension: String) throws {
        let pathExtension = Utils.getPathExtension(path)

        #expect(expectedPathExtension.isEqual(pathExtension))
    }

    @Test
    func testIsJson() {
        #expect(Utils.isJson("json"))
        #expect(Utils.isJson("jsonc"))
        #expect(Utils.isJson("gary") == false)

        #expect(Utils.isToml("toml"))
        #expect(Utils.isToml("neko"))
        #expect(Utils.isToml("gary") == false)

        #expect(Utils.isYaml("yaml"))
        #expect(Utils.isYaml("yml"))
        #expect(Utils.isYaml("gary") == false)

        #expect(Utils.isCsv("csv"))
        #expect(Utils.isCsv("gary") == false)
    }
}

@Suite
struct NekoConfigBasicLoadSuite {
    @Test func testLoadBasicJsonConfig() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.json"
        let config = try NekoFile.loadJson(NekoConfig.self, path)

        #expect("neko@v1.0.0".isEqual(config.version))
    }

    @Test func testLoadBasicTomlConfig() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.toml"
        let config = try NekoFile.loadToml(NekoConfig.self, path)

        #expect("neko@v1.0.0".isEqual(config.version))
    }

    @Test func testLoadBasicYamlConfig() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.yaml"
        let config = try NekoFile.loadYaml(NekoConfig.self, path)

        #expect("neko@v1.0.0".isEqual(config.version))
    }

    @Test func testLoadBasicCsvConfigThrowsError() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.csv"

        #expect(throws: ConfigFileLoaderError.LoadUnsupportedFormatError) {
            try NekoFileLoader.load(NekoConfig.self, path)
        }
    }

    @Test func testLoadBasicCustomFileConfigThrowsError() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.xml"

        #expect(throws: ConfigFileLoaderError.UnsupportedFormatError) {
            try NekoFileLoader.load(NekoConfig.self, path)
        }
    }

    @Test(arguments: [
        "./Tests/Data/Config/Basic/Basic.neko.json",
        "./Tests/Data/Config/Basic/Basic.neko.toml",
        "./Tests/Data/Config/Basic/Basic.neko.yaml",
        "./Tests/Data/Config/Error/Collection.NeKo.JSON",
    ])
    func testLoadBasicTomlConfig(path: String) throws {
        let config = try NekoFileLoader.load(NekoConfig.self, path)

        #expect("neko@v1.0.0".isEqual(config.version))
    }
}

@Suite
struct NekoConfigBasicLoadDataSuite {
    @Test func testLoadDataBasicTomlConfigThrowsError() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.toml"

        #expect(throws: ConfigFileLoaderError.LoadDataUnsupportedFormatError) {
            try NekoFileLoader.loadData(NekoConfig.self, path)
        }
    }

    @Test func testLoadDataBasicCustomFileConfigThrowsError() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.xls"

        #expect(throws: ConfigFileLoaderError.UnsupportedFormatError) {
            try NekoFileLoader.loadData(NekoConfig.self, path)
        }
    }

    @Test(arguments: [
        "./Tests/Data/Loader/Csv/ArrayTestConfig.csv",
        "./Tests/Data/Loader/Json/ArrayTestConfig.json",
        "./Tests/Data/Loader/Yaml/ArrayTestConfig.yaml",
    ])
    func testLoadBasicTomlConfig(path: String) throws {
        let configs = try NekoFileLoader.loadData(NekoConfig.self, path)

        #expect(configs.count == 2)

        #expect("1 Gary Ascuy".isEqual(configs[0].version))
        #expect("2 Gary Ascuy".isEqual(configs[1].version))
    }
}
