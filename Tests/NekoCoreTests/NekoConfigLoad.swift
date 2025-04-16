import Testing

@testable import NekoCore

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
        let pathExtension = NekoFileLoader.getPathExtension(path)

        #expect(expectedPathExtension.isEqual(pathExtension))
    }

    @Test
    func testIsJson() {
        #expect(NekoFileLoader.isJson("json"))
        #expect(NekoFileLoader.isJson("jsonc"))
        #expect(NekoFileLoader.isJson("gary") == false)

        #expect(NekoFileLoader.isToml("toml"))
        #expect(NekoFileLoader.isToml("neko"))
        #expect(NekoFileLoader.isToml("gary") == false)

        #expect(NekoFileLoader.isYaml("yaml"))
        #expect(NekoFileLoader.isYaml("yml"))
        #expect(NekoFileLoader.isYaml("gary") == false)

        #expect(NekoFileLoader.isCsv("csv"))
        #expect(NekoFileLoader.isCsv("gary") == false)
    }
}

@Suite
struct NekoConfigBasicLoadSuite {
    @Test func testLoadBasicJsonConfig() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.json"
        let config = try NekoFileLoader.loadJson(NekoConfig.self, fileName: path)

        #expect("neko@v1.0.0".isEqual(config.version))
    }

    @Test func testLoadBasicTomlConfig() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.toml"
        let config = try NekoFileLoader.loadToml(NekoConfig.self, fileName: path)

        #expect("neko@v1.0.0".isEqual(config.version))
    }

    @Test func testLoadBasicYamlConfig() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.yaml"
        let config = try NekoFileLoader.loadYaml(NekoConfig.self, fileName: path)

        #expect("neko@v1.0.0".isEqual(config.version))
    }

    @Test func testLoadBasicCsvConfigThrowsError() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.csv"

        #expect(throws: ConfigLoaderError.LoadUnsupportedFormatError) {
            try NekoFileLoader.load(NekoConfig.self, path)
        }
    }

    @Test func testLoadBasicCustomFileConfigThrowsError() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.xml"

        #expect(throws: ConfigLoaderError.UnsupportedFormatError) {
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

        #expect(throws: ConfigLoaderError.LoadDataUnsupportedFormatError) {
            try NekoFileLoader.loadData(NekoConfig.self, path)
        }
    }

    @Test func testLoadDataBasicCustomFileConfigThrowsError() throws {
        let path = "./Tests/Data/Config/Basic/Basic.neko.xls"

        #expect(throws: ConfigLoaderError.UnsupportedFormatError) {
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
