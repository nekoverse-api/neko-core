<div align="center">

![Neko Logo](/Docs/Logo/logo.svg)

</div>

# Neko - Nekoverse Project

**It's time for a revolution in API client technology!**

Neko is a Faster, Git-Friendly, Flexible, Extensible and Highly Plugineable API client, aimed at revolutionizing the status quo represented by Postman, Insomnia, Bruno and similar tools out there.

## Architecture

<img src="https://www.mermaidchart.com/raw/f5b55c39-1274-4bf3-a8a4-64ed78753f5a?theme=base&version=v0.1&format=svg" width="100%" />

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
