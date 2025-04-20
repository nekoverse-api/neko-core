<div align="center">

![Neko Logo](/Docs/Logo/logo.svg)

</div>

# Neko - Nekoverse Project

**It's time for a revolution in API client technology!**

Neko is a Faster, Git-Friendly, Flexible, Extensible and Highly Plugineable API client, aimed at revolutionizing the status quo represented by Postman, Insomnia, Bruno and similar tools out there.

## Architecture

<img src="https://www.mermaidchart.com/raw/f5b55c39-1274-4bf3-a8a4-64ed78753f5a?theme=base&version=v0.1&format=svg" width="100%" />


## TODO (Features)

- [x] **Neko Command Line Interface**
    - [x] Load neko config files
    - [x] Add `show` subcommand `neko show --output-format yaml ./SampleCollection.neko.jsonc`
        - [x] Add metadata for options
        - [x] Implement subcommand to show the config in different formats
        - [ ] (NiceToHave) Validate Neko Config Files
    - [x] Add `run` subcommand `neko run ./SampleCollection.neko.jsonc`
        - [x] Add metadata for options 
        - [x] Implement subcommand to show the config in different formats
    - [ ] General Improvements
        - [ ] Improve logs 
        - [ ] Add support for verbose mode 
        - [ ] Add support for dirty run
- [ ] **Neko GUI (MacOS Native App)**
    - [x] Create a POC [SwiftUI MacOs APP](https://github.com/nekoverse-api/neko-console-swiftui)
    - [ ] Create project
- [ ] **Neko in VSCode**
    - [x] Add plugin to support files (almost done since it use JSON/YAML/TOML/CSV files)
        - [x] just add *.neko as TOML in Association File in VS Code settings
    - [ ] Plugin
        - [ ] Create project action
        - [ ] Run Collection
        - [ ] Run Folder
        - [ ] Run Request 
- [ ] **Neko Core**
    - [x] Create gRPC POC [Swift gRPC Server](https://github.com/Gary-Ascuy/gRPC-Server-MacOS)
    - [x] Factory
        - [x] Add support for loaders in factory 
        - [x] Add support for executors in factory 
        - [x] Add support for testers in factory 
     - [x] NekoRunCollection
        - [x] Support folders 
        - [x] Support requests
        - [x] Support message notification
        - [ ] Support Variables 
        - [ ] Support Data Variables
    - [x] NekoMustacheTemplate
        - [x] Add support for templates
        - [x] Add support for variables in template
        - [x] Add support for nested variables in template
        - [x] Add support 
    - [ ] Loader
        - [x] AlamofireNekoNetwork
            - [x] Perform requests
            - [x] Get metadata from request & response
                - [x] Size of Request & Response for Body and Headers
                - [x] Duration of phases (e.g. DnsLookup, SSLHandshake, Download, ...)
                - [x] Duration in miliseconds of phases (e.g. DnsLookup, SSLHandshake, Download, ...)
                - [x] TLS metadata (TLS Protocol Version, TLS Cipher Suite)
                - [x] IP & Port of local and remote 
        - [x] NekoFileLoader
            - [x] Add support for TOML files
            - [x] Add support for YAML files
            - [x] Add support for JSON files
            - [x] Add support for CSV files
        - Plugins
            - [x] Define models and protocols 
            - [x] Add File loader plugin
            - [ ] Add GitFriendly loader plugin
            - [ ] Add gRPC loader plugin
                - [ ] Create gRPC Plugin as template for Community Support
    - [ ] Executor
        - [ ] Plugins
            - [x] Define models and protocols
            - [x] Add Native executor plugin
            - [ ] Add gRPC executor plugins
                - [ ] Create gRPC Plugin as template for Community Support
    - [ ] Tester 
        - JavaScript Sandbox for test scripts
        - [ ] Plugins 
            - [x] Define models and protocols
            - [ ] Add support for JavaScript plugin
                - [ ] Add support for unit tests
                - [ ] Add support for reports
            - [ ] Add support for gRPC plugins
                - [ ] Create gRPC Plugin as template for Community Support 
                - [ ] Add support for unit tests
                - [ ] Add support for reports

## Local Development 

Build Project 
```sh
swift build
```

Run CLI 
```sh
swift run
```

Run Unit Tests
```sh
swift test
```

## Neko CLI 

```sh
swift run neko --help 

swift run neko show --help 
swift run neko show ./neko_collection

swift run neko run --help
swift run neko run ./neko_collection
```

for tests
```sh
swift run neko run ./Samples/config.neko.json 
```

Show 
```sh
brew install jq # Json Query 
brew install yq # Yaml Query
brew install tq # Toml Query
brew install dasel # Toml Query but also support JSON, YAML, TOML, XML

swift run neko show --output-format json  ./Samples/demo.neko.jsonc | jq
swift run neko show --output-format yaml ./Samples/demo.neko.jsonc | yq
swift run neko show --output-format toml ./Samples/demo.neko.jsonc | tq .
swift run neko show --output-format toml ./Samples/demo.neko.jsonc | dasel -r toml

```

## Trademark

**Logo**

The [Neko Logo](https://www.svgrepo.com/svg/423820/cat-origami-paper) is sourced from [Lima Studio](https://www.svgrepo.com/author/Lima%20Studio/). License: [CC BY](https://www.svgrepo.com/page/licensing/#CC%20Attribution)

## References 

- https://www.swift.org/getting-started/
- https://www.swift.org/getting-started/cli-swiftpm/
- https://www.swift.org/documentation/package-manager/
- https://docs.swift.org/swift-book/documentation/the-swift-programming-language/

- https://swiftpackageindex.com/
- https://www.avanderlee.com/swift-testing/expect-macro/
