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
struct NekoConfigBasicSuite {
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
            try NekoFileLoader.load(NekoConfig.self, fileName: path)
        }
    }

    @Test(arguments: [
        "./Tests/Data/Config/Basic/Basic.neko.json",
        "./Tests/Data/Config/Basic/Basic.neko.toml",
        "./Tests/Data/Config/Basic/Basic.neko.yaml",
        "./Tests/Data/Config/Error/Collection.NeKo.JSON",
    ])
    func testLoadBasicTomlConfig(path: String) throws {
        let config = try NekoFileLoader.load(NekoConfig.self, fileName: path)

        #expect("neko@v1.0.0".isEqual(config.version))
    }
}
