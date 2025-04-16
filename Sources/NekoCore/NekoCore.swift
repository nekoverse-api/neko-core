import CSV
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

    public static func loadCsv<T>(_ type: T.Type, _ path: String) throws -> [T]
    where T: Decodable {
        let decoder = CSVRowDecoder()

        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let value = String(decoding: data, as: UTF8.self)
            let reader = try CSVReader(string: value, hasHeaderRow: true, trimFields: true)

            var records = [T]()
            while reader.next() != nil {
                let row = try decoder.decode(type, from: reader)
                records.append(row)
            }
            return records
        } catch {
            throw error
        }
    }

    public static func load<T>(_ type: T.Type, _ path: String) throws -> T
    where T: Decodable {
        let pathExtension = getPathExtension(path)

        if isJson(pathExtension) {
            return try self.loadJson(type, fileName: path)
        }

        if isToml(pathExtension) {
            return try self.loadToml(type, fileName: path)
        }

        if isYaml(pathExtension) {
            return try self.loadYaml(type, fileName: path)
        }

        if isCsv(pathExtension) {
            throw ConfigLoaderError.LoadUnsupportedFormatError
        }

        throw ConfigLoaderError.UnsupportedFormatError
    }

    public static func loadData<T>(_ type: T.Type, _ path: String) throws -> [T]
    where T: Decodable {
        let pathExtension = getPathExtension(path)

        if isCsv(pathExtension) {
            return try loadCsv(type, path)
        }

        if isJson(pathExtension) {
            return try loadJson([T].self, fileName: path)
        }

        if isToml(pathExtension) {
            throw ConfigLoaderError.LoadDataUnsupportedFormatError
        }

        if isYaml(pathExtension) {
            return try self.loadYaml([T].self, fileName: path)
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

    public static func isCsv(_ pathExtension: String) -> Bool {
        let EXTENSIONS = ["csv"]
        return EXTENSIONS.contains { $0.isEqual(pathExtension) }
    }
}

public enum ConfigLoaderError: Error {
    case UnsupportedFormatError
    case LoadUnsupportedFormatError
    case LoadDataUnsupportedFormatError
}
