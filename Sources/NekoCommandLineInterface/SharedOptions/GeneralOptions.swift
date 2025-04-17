import ArgumentParser

struct GeneralOptions: ParsableArguments {
    @Flag(name: .shortAndLong)
    var verbose = false
}
