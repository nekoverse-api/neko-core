import ArgumentParser
import NekoCore

@main
struct Neko: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "neko",
        version: NekoCore.version,
        subcommands: [ShowNekoCommand.self, RunNekoCommand.self]
    )
}
