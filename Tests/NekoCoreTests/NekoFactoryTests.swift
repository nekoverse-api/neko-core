import Foundation
import Testing

@testable import NekoCore

@Suite
struct NekoFactoryTests {
    func plugin(name: String) -> NekoPlugin {
        return NekoPlugin(name: name, properties: [:])
    }

    @Test
    func testLoaderFactoryUtils() async throws {
        typealias utils = NekoCore.LoaderFactoryUtils

        // GitFriendly
        #expect(utils.isGitFriendly(plugin(name: "GitFriendly")) == true)
        #expect(utils.isGitFriendly(plugin(name: "gitfriendly")) == true)
        #expect(utils.isGitFriendly(plugin(name: "GitFriendlyPlugin")) == true)
        #expect(utils.isGitFriendly(plugin(name: "gitfriendlyplugin")) == true)

        #expect(utils.isGitFriendly(plugin(name: "GatFriendly")) == false)
        #expect(utils.isGitFriendly(plugin(name: "gatfriendly")) == false)
        #expect(utils.isGitFriendly(plugin(name: "GotFriendlyPlugin")) == false)
        #expect(utils.isGitFriendly(plugin(name: "gotfriendlyplugin")) == false)

        // Native
        #expect(utils.isNative(plugin(name: "Native")) == true)
        #expect(utils.isNative(plugin(name: "native")) == true)
        #expect(utils.isNative(plugin(name: "NativePlugin")) == true)
        #expect(utils.isNative(plugin(name: "nativeplugin")) == true)

        #expect(utils.isNative(plugin(name: "Notivo")) == false)
        #expect(utils.isNative(plugin(name: "notivo")) == false)
        #expect(utils.isNative(plugin(name: "NotivoPlugin")) == false)
        #expect(utils.isNative(plugin(name: "notivoplugin")) == false)

        // GRPCFactoryUtils
        #expect(utils.isGRPC(plugin(name: "gRPC")) == true)
        #expect(utils.isGRPC(plugin(name: "grpc")) == true)
        #expect(utils.isGRPC(plugin(name: "gRPCPlugin")) == true)
        #expect(utils.isGRPC(plugin(name: "grpcplugin")) == true)

        #expect(utils.isGRPC(plugin(name: "dRPC")) == false)
        #expect(utils.isGRPC(plugin(name: "drpc")) == false)
        #expect(utils.isGRPC(plugin(name: "dRPCPlugin")) == false)
        #expect(utils.isGRPC(plugin(name: "drpcplugin")) == false)
    }

    @Test
    func testExecutorFactoryUtils() async throws {
        typealias utils = NekoCore.ExecutorFactoryUtils

        // Native
        #expect(utils.isNative(plugin(name: "Native")) == true)
        #expect(utils.isNative(plugin(name: "native")) == true)
        #expect(utils.isNative(plugin(name: "NativePlugin")) == true)
        #expect(utils.isNative(plugin(name: "nativeplugin")) == true)

        #expect(utils.isNative(plugin(name: "Notivo")) == false)
        #expect(utils.isNative(plugin(name: "notivo")) == false)
        #expect(utils.isNative(plugin(name: "NotivoPlugin")) == false)
        #expect(utils.isNative(plugin(name: "notivoplugin")) == false)

        // GRPCFactoryUtils
        #expect(utils.isGRPC(plugin(name: "gRPC")) == true)
        #expect(utils.isGRPC(plugin(name: "grpc")) == true)
        #expect(utils.isGRPC(plugin(name: "gRPCPlugin")) == true)
        #expect(utils.isGRPC(plugin(name: "grpcplugin")) == true)

        #expect(utils.isGRPC(plugin(name: "dRPC")) == false)
        #expect(utils.isGRPC(plugin(name: "drpc")) == false)
        #expect(utils.isGRPC(plugin(name: "dRPCPlugin")) == false)
        #expect(utils.isGRPC(plugin(name: "drpcplugin")) == false)
    }

    @Test
    func testTesterFactoryUtils() async throws {
        typealias utils = NekoCore.TesterFactoryUtils

        // Native
        #expect(utils.isJavaScript(plugin(name: "JavaScript")) == true)
        #expect(utils.isJavaScript(plugin(name: "javascript")) == true)
        #expect(utils.isJavaScript(plugin(name: "JavaScriptPlugin")) == true)
        #expect(utils.isJavaScript(plugin(name: "javascriptplugin")) == true)

        #expect(utils.isJavaScript(plugin(name: "CoffeeScript")) == false)
        #expect(utils.isJavaScript(plugin(name: "coffeescript")) == false)
        #expect(utils.isJavaScript(plugin(name: "CoffeeScriptPlugin")) == false)
        #expect(utils.isJavaScript(plugin(name: "coffeescriptplugin")) == false)

        // GRPCFactoryUtils
        #expect(utils.isGRPC(plugin(name: "gRPC")) == true)
        #expect(utils.isGRPC(plugin(name: "grpc")) == true)
        #expect(utils.isGRPC(plugin(name: "gRPCPlugin")) == true)
        #expect(utils.isGRPC(plugin(name: "grpcplugin")) == true)

        #expect(utils.isGRPC(plugin(name: "dRPC")) == false)
        #expect(utils.isGRPC(plugin(name: "drpc")) == false)
        #expect(utils.isGRPC(plugin(name: "dRPCPlugin")) == false)
        #expect(utils.isGRPC(plugin(name: "drpcplugin")) == false)
    }

    @Test
    func testFactory() async throws {
        typealias factory = NekoCore.Factory

        #expect(factory.getLoaderBy("GitFriendly", [:]) as? GitFriendlyLoaderPlugin != nil)
        #expect(factory.getLoaderBy("Native", [:]) as? NativeLoaderPlugin != nil)
        #expect(factory.getLoaderBy("gRPC", [:]) as? GRPCLoaderPlugin != nil)

        #expect(factory.getExecutorBy("Native", [:]) as? NativeExecutorPlugin != nil)
        #expect(factory.getExecutorBy("gRPC", [:]) as? GRPCExecutorPlugin != nil)

        #expect(factory.getTesterBy("JavaScript", [:]) as? JavaScriptTesterPlugin != nil)
        #expect(factory.getTesterBy("gRPC", [:]) as? GRPCTesterPlugin != nil)
    }
}
