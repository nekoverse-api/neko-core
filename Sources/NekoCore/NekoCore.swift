import Foundation
import TOMLDecoder
import Yams

public struct NekoFileLoader {
    public static func loadJson<T>(_ type: T.Type, fileName: String) throws -> T
    where T: Decodable {
        let decoder = JSONDecoder()
        decoder.allowsJSON5 = true

        do {
            let url = URL(fileURLWithPath: fileName)
            let data = try Data(contentsOf: url)
            let config = try decoder.decode(type, from: data)
            return config
        } catch {
            throw error
        }
    }

    public static func loadYaml<T>(_ type: T.Type, fileName: String) throws -> T
    where T: Decodable {
        let decoder = YAMLDecoder()

        do {
            let url = URL(fileURLWithPath: fileName)
            let data = try Data(contentsOf: url)
            let config = try decoder.decode(type, from: data)
            return config
        } catch {
            throw error
        }
    }

    public static func loadToml<T>(_ type: T.Type, fileName: String) throws -> T
    where T: Decodable {
        let decoder = TOMLDecoder()

        do {
            let url = URL(fileURLWithPath: fileName)
            let data = try Data(contentsOf: url)
            let config = try decoder.decode(type, from: data)
            return config
        } catch {
            throw error
        }
    }

    public static func load<T>(_ type: T.Type, fileName: String) throws -> T
    where T: Decodable {
        let pathExtension = getPathExtension(fileName)

        if isJson(pathExtension) {
            return try self.loadJson(type, fileName: fileName)
        }

        if isToml(pathExtension) {
            return try self.loadToml(type, fileName: fileName)
        }

        if isYaml(pathExtension) {
            return try self.loadYaml(type, fileName: fileName)
        }

        throw ConfigLoaderError.UnsupportedFormatError
    }

    public static func getPathExtension(_ path: String) -> String {
        let pathExtension = URL(string: path)?.pathExtension ?? "neko"
        return pathExtension.lowercased()
    }

    public static func isJson(_ pathExtension: String) -> Bool {
        let EXTENSIONS = ["json", "jsonc"]
        return EXTENSIONS.contains { $0.isEqual(pathExtension) }
    }

    public static func isToml(_ pathExtension: String) -> Bool {
        let EXTENSIONS = ["toml", "neko"]
        return EXTENSIONS.contains { $0.isEqual(pathExtension) }
    }

    public static func isYaml(_ pathExtension: String) -> Bool {
        let EXTENSIONS = ["yaml", "yml"]
        return EXTENSIONS.contains { $0.isEqual(pathExtension) }
    }
}

public enum ConfigLoaderError: Error {
    case UnsupportedFormatError
}
