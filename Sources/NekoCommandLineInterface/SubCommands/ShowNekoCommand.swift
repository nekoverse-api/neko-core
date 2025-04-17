import ArgumentParser

struct ShowNekoCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "show", abstract: "Shows Neko Project Config")

    func run() async throws {
        print("show config")
    }
}
