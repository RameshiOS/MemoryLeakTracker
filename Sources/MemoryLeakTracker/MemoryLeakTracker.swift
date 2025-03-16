import Foundation
import ObjectiveC.runtime

public final class MemoryLeakDetector {
    public static let shared = MemoryLeakDetector()
    private var leakedObjects = Set<String>()

    private init() {
        swizzleDeinit()
    }

    private func swizzleDeinit() {
        let originalSelector = NSSelectorFromString("dealloc")
        let swizzledSelector = #selector(swizzledDealloc)

        let originalMethod = class_getInstanceMethod(NSObject.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(NSObject.self, swizzledSelector)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    @objc private func swizzledDealloc() {
        let className = String(describing: type(of: self))

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if CFGetRetainCount(self) > 1 {
                MemoryLeakDetector.shared.leakedObjects.insert(className)
                LeakLogger.shared.log("🛑 Memory leak detected: \(className)")
                LeakMonitor.shared.reportLeak(className)
            }
        }

        // Call the original dealloc
        swizzledDealloc()
    }

    public func checkForLeaks() -> Bool {
        return !leakedObjects.isEmpty
    }
}
