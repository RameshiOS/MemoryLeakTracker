import Foundation

public final class LeakLogger {
    public static let shared = LeakLogger()
    private let logFile = FileManager.default.temporaryDirectory.appendingPathComponent("MemoryLeaks.log")

    private init() {}

    public func log(_ message: String) {
        let logMessage = "\(Date()): \(message)\n"
        if let data = logMessage.data(using: .utf8) {
            try? data.append(to: logFile)
        }
    }

    public var logFileURL: URL {
        return logFile
    }
}

extension Data {
    func append(to url: URL) throws {
        if FileManager.default.fileExists(atPath: url.path) {
            let fileHandle = try FileHandle(forWritingTo: url)
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
            fileHandle.closeFile()
        } else {
            try write(to: url)
        }
    }
}
