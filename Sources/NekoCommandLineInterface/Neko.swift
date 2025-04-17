import ArgumentParser
import NekoCore

@main
struct Neko: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "neko",
        version: "0.0.1",
        subcommands: [ShowNekoCommand.self, RunNekoCommand.self]
    )
}
