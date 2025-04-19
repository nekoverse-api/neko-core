import Foundation
import Testing

@testable import NekoCore

@Suite
struct NekoNetworkMeasurementTests {
    @Test
    func testFromNekoHttpBasicParams() async throws {
        var clock = NekoCore.NekoNetworkMeasurement()
        usleep(2000)
        clock.addCheckpoint(NekoPhase.Prepare)
        usleep(2000)
        clock.addCheckpoint(NekoPhase.Download)
        usleep(2000)
        clock.addCheckpoint(NekoPhase.Process)

        let time = clock.getTimeMeasurement()
        #expect(time[.Prepare]! >= Duration.microseconds(2000))
        #expect(time[.Download]! >= Duration.microseconds(2000))
        #expect(time[.Process]! >= Duration.microseconds(2000))
    }
}
