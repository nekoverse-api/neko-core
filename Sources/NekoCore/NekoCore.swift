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
}
