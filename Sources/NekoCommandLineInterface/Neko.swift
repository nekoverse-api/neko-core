import ArgumentParser
import NekoCore

@main
struct Neko: ParsableCommand {
    mutating func run() throws {
        print("Hello, Neko!")
    }
}
