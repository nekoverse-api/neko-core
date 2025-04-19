import Foundation
import Testing

@testable import NekoCore

@Suite
struct SharedTests {
    @Test
    func testFromNekoHttpBasicParams() async throws {
        let http = NekoHttp(url: "https://echo.nekoverse.me/test", method: "GET")
        let res = NekoCore.fromNekoHttp(http)

        #expect(res.url.isEqual(http.url))
        #expect(res.method.isEqual(http.method))
        #expect(res.parameters.count == 0)
        #expect(res.headers.count == 0)
        #expect(res.body == nil)
    }

    @Test
    func testFromNekoHttpAllParams() async throws {
        let http = NekoHttp(
            url: "https://echo.nekoverse.me/test",
            method: "GET",
            body: "TEST BODY",
            parameters: ["query": "gary"],
            headers: ["Content-Type": "application/json", "Accept": "application/json"]
        )
        let req = NekoCore.fromNekoHttp(http)

        #expect(req.url.isEqual(http.url))
        #expect(req.method.isEqual(http.method))
        #expect(req.parameters.count == 1)
        #expect(req.headers.count == 2)
        #expect(req.body != nil)
        #expect(req.body?.isEqual("TEST BODY") ?? false)
    }

    @Test
    func testBuildRequestAllParams() async throws {
        let req = NekoRequest(
            url: "https://echo.nekoverse.me/test",
            method: "GET",
            parameters: ["query": "gary"],
            headers: ["Content-Type": "application/json", "Accept": "application/json"],
            body: "TEST BODY",
            context: ""
        )

        let urlRequest = try NekoCore.buildRequest(req)
        #expect("https://echo.nekoverse.me/test".isEqual(urlRequest.url?.absoluteString))
        #expect(req.method.isEqual(urlRequest.httpMethod))
        #expect(urlRequest.headers.count == 2)

        #expect(urlRequest.httpBody != nil)
        #expect(urlRequest.httpBody?.count == 9)
        #expect("TEST BODY".isEqual(String(data: urlRequest.httpBody!, encoding: .utf8)))
    }

    @Test
    func testDurationBetweenDates() async throws {
        let start = Date()
        let end = start + 1

        let duration = NekoCore.Shared.durationBetweenDates(start, end)
        #expect(duration.components.seconds >= 1)
        #expect(duration.components.attoseconds == 0)
    }

    @Test
    func testDurationBetweenDatesEdgeCases() async throws {
        let start = Date()
        let end = start + 1

        #expect(NekoCore.Shared.durationBetweenDates(nil, nil) == Duration.seconds(0))
        #expect(NekoCore.Shared.durationBetweenDates(start, nil) == Duration.seconds(0))
        #expect(NekoCore.Shared.durationBetweenDates(nil, end) == Duration.seconds(0))
    }
}
