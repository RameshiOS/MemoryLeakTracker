import XCTest
@testable import MemoryLeakTracker

final class MemoryLeakTrackerTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MemoryLeakTracker().text, "Hello, World!")
    }
}
