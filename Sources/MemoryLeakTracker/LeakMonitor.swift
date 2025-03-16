import Foundation
import Combine

public final class LeakMonitor: ObservableObject {
    public static let shared = LeakMonitor()
    
    @Published public private(set) var leakedObjects: [String] = []

    private init() {}

    public func reportLeak(_ objectName: String) {
        DispatchQueue.main.async {
            if !self.leakedObjects.contains(objectName) {
                self.leakedObjects.append(objectName)
            }
        }
    }
}
