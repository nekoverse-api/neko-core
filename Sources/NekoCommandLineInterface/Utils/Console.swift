struct cli {
    static func success(_ string: String) {
        let icon = "[成功]"
        print("\(icon) \(string)".green)
    }

    static func warning(_ string: String) {
        let icon = "[警告]"
        print("\(icon) \(string)".yellow)
    }

    static func error(_ string: String) {
        let icon = "[失敗]"
        print("\(icon) \(string)".red)
    }

    static func title(_ string: String) {
        print("\(string)".blue)
    }
}
