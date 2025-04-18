import CSV
import Foundation
import TOMLDecoder
import TOMLKit
import Yams

public enum ConfigFileLoaderError: Error {
    case UnsupportedFormatError
    case LoadUnsupportedFormatError
    case LoadDataUnsupportedFormatError
    case UnableToConvertAsString
}

public struct NekoFileLoader {
    /**
     * Utils for NekoFileLoader
     */
    public struct Utils {
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

    /**
     * Loads different file formats
     */
    struct NekoFile {
        public static func loadJson<T>(_ type: T.Type, _ path: String) throws -> T
        where T: Decodable {
            let decoder = JSONDecoder()
            decoder.allowsJSON5 = true

            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let config = try decoder.decode(type, from: data)
                return config
            } catch {
                throw error
            }
        }

        public static func loadYaml<T>(_ type: T.Type, _ path: String) throws -> T
        where T: Decodable {
            let decoder = YAMLDecoder()

            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let config = try decoder.decode(type, from: data)
                return config
            } catch {
                throw error
            }
        }

        public static func loadToml<T>(_ type: T.Type, _ path: String) throws -> T
        where T: Decodable {
            let decoder = TOMLDecoder()

            do {
                let url = URL(fileURLWithPath: path)
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

        public static func asJson<T>(_ value: T) throws -> String
        where T: Encodable {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(value)
                guard let string = String(data: data, encoding: .utf8) else {
                    throw ConfigFileLoaderError.UnableToConvertAsString
                }
                return string
            } catch {
                throw error
            }
        }

        public static func asYaml<T>(_ value: T) throws -> String
        where T: Encodable {
            do {
                let encoder = YAMLEncoder()
                return try encoder.encode(value)
            } catch {
                throw error
            }
        }

        public static func asToml<T>(_ value: T) throws -> String
        where T: Encodable {
            do {
                // TODO: this is the second lib to encode/decode TOML (Refactor)
                let encoder = TOMLEncoder()
                return try encoder.encode(value)
            } catch {
                throw error
            }
        }
    }

    /**
     * Loads an object from file
     */
    public static func load<T>(_ type: T.Type, _ path: String) throws -> T
    where T: Decodable {
        do {
            let pathExtension = Utils.getPathExtension(path)

            if Utils.isJson(pathExtension) {
                return try NekoFile.loadJson(type, path)
            }

            if Utils.isToml(pathExtension) {
                return try NekoFile.loadToml(type, path)
            }

            if Utils.isYaml(pathExtension) {
                return try NekoFile.loadYaml(type, path)
            }

            if Utils.isCsv(pathExtension) {
                throw ConfigFileLoaderError.LoadUnsupportedFormatError
            }
        } catch {
            throw error
        }

        throw ConfigFileLoaderError.UnsupportedFormatError
    }

    /**
     * Loads an array from file
     */
    public static func loadData<T>(_ type: T.Type, _ path: String) throws -> [T]
    where T: Decodable {
        do {
            let pathExtension = Utils.getPathExtension(path)

            if Utils.isCsv(pathExtension) {
                return try NekoFile.loadCsv(type, path)
            }

            if Utils.isJson(pathExtension) {
                return try NekoFile.loadJson([T].self, path)
            }

            if Utils.isToml(pathExtension) {
                throw ConfigFileLoaderError.LoadDataUnsupportedFormatError
            }

            if Utils.isYaml(pathExtension) {
                return try NekoFile.loadYaml([T].self, path)
            }
        } catch {
            throw error
        }

        throw ConfigFileLoaderError.UnsupportedFormatError
    }
}
