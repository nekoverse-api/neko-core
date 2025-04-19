public enum NekoAssertType: String, Codable {
    case Passed
    case Skipped
    case Failed
}

public struct NekoAssert: Codable {
    public var name: String
    public var type: NekoAssertType
    public var errors: String
}

public struct NekoTestResponse: Codable {
    public var type: NekoAssertType

    public var asserts: [NekoAssert]
}
