import NekoCore

extension String {
    func leftPadding(toLength: Int, using character: Character) -> String {
        if count < toLength {
            return String(repeating: character, count: toLength - count) + self
        } else {
            return self
        }
    }
}

extension Double {
    func toInt() -> Int? {
        if self >= Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}

struct cli {
    static let DEFAULT_FORMAT = Duration.UnitsFormatStyle.units(
        allowed: [.milliseconds], fractionalPart: .show(length: 2))

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

    static func showTime(_ time: [NekoPhase: Duration]) {
        let length = 35
        var start: Duration = .milliseconds(0)
        guard let total = time[.TOTAL] else { return }
        if total == start { return }

        printTimeValue("SocketInitialization:", time[.SocketInitialization], length, total, start)
        start += time[.SocketInitialization] ?? .milliseconds(0)

        printTimeValue("DnsLookup:", time[.DnsLookup], length, total, start)
        start += time[.DnsLookup] ?? .milliseconds(0)

        printTimeValue("TCPHandshake:", time[.TCPHandshake], length, total, start)
        start += time[.TCPHandshake] ?? .milliseconds(0)

        printTimeValue("SSLHandshake:", time[.SSLHandshake], length, total, start)
        start += time[.SSLHandshake] ?? .milliseconds(0)

        printTimeValue("WaitingTTFB:", time[.WaitingTimeToFirstByte], length, total, start)
        start += time[.WaitingTimeToFirstByte] ?? .milliseconds(0)

        printTimeValue("Download:", time[.Download], length, total, start)
    }

    static func printTimeValue(
        _ name: String, _ value: Duration?, _ spaces: Int, _ total: Duration, _ start: Duration
    ) {
        guard let value else { return }
        let valueInMs = value.formatted(DEFAULT_FORMAT)

        let startingAt = start / total
        let percentage = value / total

        let prop = getTimeProp(name, valueInMs, spaces)
        let progress = getProgress(startingAt, percentage, 35, name.isEqual("Download:"))
        let colorProgress = name.isEqual("WaitingTTFB:") ? progress.red : progress.blue

        print("\(prop) |\(colorProgress)| \(getPercentage(percentage * 100)) |")
    }

    static func getProgress(_ start: Double, _ percentage: Double, _ size: Int, _ last: Bool)
        -> String
    {
        guard let start = Double(start * Double(size)).toInt() else { return "Error" }
        guard let percentage = Double(percentage * Double(size)).toInt() else { return "Error" }

        let p =
            percentage == 0
            ? (last ? "\u{25A9}" : "\u{258F}")
            : "".padding(toLength: percentage, withPad: "\u{25A9}", startingAt: 0)

        let s = "".padding(toLength: start, withPad: " ", startingAt: 0)
        return "\(s)\(p)".padding(toLength: 35, withPad: " ", startingAt: 0)

    }

    static func getPercentage(_ percentage: Double) -> String {
        let value = String(format: "%.2f %%", percentage)
        return value.leftPadding(toLength: 8, using: " ")
    }

    static func getTimeProp(_ name: String, _ value: String, _ spaces: Int) -> String {
        let missing = spaces - name.count - value.count
        let pad = missing > 0 ? "".padding(toLength: missing, withPad: " ", startingAt: 0) : ""
        return "\(name)\(pad)\(value)"
    }
}
