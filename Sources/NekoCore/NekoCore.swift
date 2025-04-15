import Foundation

public struct NekoFileLoader {
    public static func loadJson<T>(_ type: T.Type, fileName: String) throws -> T
    where T: Decodable {
        let decoder = JSONDecoder()
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
