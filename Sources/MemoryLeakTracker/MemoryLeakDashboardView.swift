import SwiftUI

public struct MemoryLeakDashboardView: View {
    @ObservedObject var monitor = LeakMonitor.shared
    @State private var showShareSheet = false

    public init() {}

    public var body: some View {
        VStack {
            Text("🛑 Memory Leak Dashboard (\(monitor.leakedObjects.count))")
                .font(.headline)
                .padding()

            if monitor.leakedObjects.isEmpty {
                Text("✅ No leaks detected.")
                    .foregroundColor(.green)
                    .padding()
            } else {
                List(monitor.leakedObjects, id: \.self) { leak in
                    HStack {
                        Text(leak)
                        Spacer()
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                    }
                }
            }

            Button("Export Logs") {
                showShareSheet = true
            }
            .padding()
            .sheet(isPresented: $showShareSheet) {
                ActivityView(activityItems: [LeakLogger.shared.logFileURL])
            }
        }
        .padding()
    }
}
