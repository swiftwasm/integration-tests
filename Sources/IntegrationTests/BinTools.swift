import Foundation

func installTool(_ name: String, destination: String) {
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
    guard !FileManager.default.fileExists(atPath: binPath.path) else {
        return
    }
    installTool("wasmer", destination: binPath.path)
    installTool("wasmtime", destination: binPath.path)
}
