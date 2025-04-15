import Testing

@testable import NekoCore

@Test func testAdd() async throws {
    let response = add(a: 342, b: 324)
    #expect(response == 666)
}
