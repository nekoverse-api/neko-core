import Alamofire
import Foundation

extension NekoCore {
    /// Example: `iOS NekoCli/1.0.0 (com.ziogd.neko; build:1; iOS 13.0.0)`
    public struct NekoNetworkSession {
        public static let session = {
            let configuration: URLSessionConfiguration = URLSessionConfiguration.af.default
            configuration.headers = [
                .defaultAcceptEncoding,
                .defaultAcceptLanguage,
                NekoCore.NekoNetworkSession.nekoUserAgent,
            ]

            return Session(configuration: configuration)
        }()

        public static let nekoUserAgent: HTTPHeader = {
            let info = Bundle.main.infoDictionary

            let executable =
                (info?["CFBundleExecutable"] as? String)
                ?? (ProcessInfo.processInfo.arguments.first?.split(separator: "/").last.map(
                    String.init)) ?? "neko"

            let bundle = info?["CFBundleIdentifier"] as? String ?? "com.ziogd.neko"
            let appVersion = info?["CFBundleShortVersionString"] as? String ?? "0.1"
            let appBuild = info?["CFBundleVersion"] as? String ?? "0.0.1"

            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString =
                    "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                let osName: String = {
                    #if os(iOS)
                        #if targetEnvironment(macCatalyst)
                            return "macOS(Catalyst)"
                        #else
                            return "iOS"
                        #endif
                    #elseif os(watchOS)
                        return "watchOS"
                    #elseif os(tvOS)
                        return "tvOS"
                    #elseif os(macOS)
                        #if targetEnvironment(macCatalyst)
                            return "macOS(Catalyst)"
                        #else
                            return "macOS"
                        #endif
                    #elseif swift(>=5.9.2) && os(visionOS)
                        return "visionOS"
                    #elseif os(Linux)
                        return "Linux"
                    #elseif os(Windows)
                        return "Windows"
                    #elseif os(Android)
                        return "Android"
                    #else
                        return "Unknown"
                    #endif
                }()

                return "\(osName) \(versionString)"
            }()

            let userAgent =
                "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion))"

            return .userAgent(userAgent)
        }()
    }
}
