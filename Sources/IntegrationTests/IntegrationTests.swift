import Foundation

let testCasesPath = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appendingPathComponent("TestCases")

public func main() throws {
    let toolchains = downloadToolchains()
    let testCases = try FileManager.default.contentsOfDirectory(atPath: testCasesPath.path)
    
    for testCase in testCases {
        let testScript = testCasesPath.appendingPathComponent(testCase).appendingPathComponent("test.sh")
        print(testScript.path)
        guard FileManager.default.fileExists(atPath: testScript.path) else {
            continue
        }
        print("Run", testScript)
        for (_, toolchain) in toolchains {
            runTest(testScript: testScript, toolchain: toolchain)
        }
    }
}

func runTest(testScript: URL, toolchain: URL) {
    print("Running \(testScript)")
    let process = Process()
    var environment = ProcessInfo.processInfo.environment
    environment["TOOLCHAIN"] = toolchain.path
    process.launchPath = testScript.path
    process.environment = environment
    process.launch()
    process.waitUntilExit()
    guard process.terminationStatus == 0 else {
        fatalError("""
        Test failed: TOOLCHAIN=\(toolchain.path) \(testScript.path)
        """)
    }
}

