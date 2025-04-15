// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import NekoCore

@main
struct Neko: ParsableCommand {
    mutating func run() throws {
        print("Hello, world! \(add(a: 1, b: 2))")
    }
}
