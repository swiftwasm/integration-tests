import Foundation

func installTool(_ name: String, destination: String) {
    let toolPath = binPath.appendingPathComponent(name)
    guard !FileManager.default.fileExists(atPath: toolPath.path) else {
        return
    }
    let scripts = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("scripts")
    let installer = scripts.appendingPathComponent("install-\(name).sh")
    let process = Process()
    process.launchPath = installer.path
    process.arguments = [destination]
    process.launch()
    process.waitUntilExit()
}

let binPath = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appendingPathComponent("bin")

func installTools() {
    installTool("wasmtime", destination: binPath.path)
}
