public struct NekoNetworkMeasurement {
    let clock: ContinuousClock = ContinuousClock()
    var time = [NekoPhase: Duration]()

    var start: ContinuousClock.Instant
    var end: ContinuousClock.Instant

    public init() {
        self.start = clock.now
        self.end = self.start
    }

    mutating func addCheckpoint(_ phase: NekoPhase) {
        self.end = clock.now
        self.time[phase] = start.duration(to: self.end)
        self.start = self.end
    }

    func getTimeMeasurement() -> [NekoPhase: Duration] {
        return time
    }
}
