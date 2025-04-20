import NekoCore

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

    static func showTime(_ time: [NekoPhase: Duration]) {
        let length = 35
        printTimeValue("SocketInitialization:", time[.SocketInitialization], length)
        printTimeValue("DnsLookup:", time[.DnsLookup], length)
        printTimeValue("TCPHandshake:", time[.TCPHandshake], length)
        printTimeValue("SSLHandshake:", time[.SSLHandshake], length)
        printTimeValue("WaitingTTFB:", time[.WaitingTimeToFirstByte], length)
        printTimeValue("Download:", time[.Download], length)
    }

    static func printTimeValue(
        _ name: String, _ value: Duration?, _ spaces: Int
    ) {
        let value =
            value?.formatted(.units(allowed: [.milliseconds], fractionalPart: .show(length: 2)))
            ?? "0 ms"
        let missing = spaces - name.count - value.count
        let pad = missing > 0 ? "".padding(toLength: missing, withPad: " ", startingAt: 0) : ""
        print("\(name)\(pad)\(value) |              \("=======".blue)                     | 95% |")
    }

}
