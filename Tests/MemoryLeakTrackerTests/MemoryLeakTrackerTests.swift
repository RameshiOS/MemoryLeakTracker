import XCTest
import MemoryLeakTracker

final class MemoryLeakTests: XCTestCase {
    func testMemoryLeaks() {
        let detector = MemoryLeakDetector.shared
        
        // Allow time for tracking leaks
        sleep(3)

        XCTAssertFalse(detector.checkForLeaks(), "🛑 Memory leaks detected! Blocking PR merge.")
    }
}
