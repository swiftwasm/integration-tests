let toolchainVersions = [
    "swift-wasm-DEVELOPMENT-SNAPSHOT-2020-10-22-a",
    "swift-wasm-5.3-SNAPSHOT-2020-10-21-a",
]

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func hostSuffix() -> String {
    #if os(macOS)
    return "macos_x86_64.pkg"
    #elseif os(Linux)
    let releaseFile = "/etc/lsb-release"
    let releaseData = try! String(contentsOfFile: releaseFile)
    let ubuntuSuffix: String
    if releaseData.contains("DISTRIB_RELEASE=18.04") {
      ubuntuSuffix = "ubuntu18.04"
    } else if releaseData.contains("DISTRIB_RELEASE=20.04") {
      ubuntuSuffix = "ubuntu20.04"
    } else {
      fatalError("unsupported linux os")
    }

    return "\(ubuntuSuffix)_x86_64.tar.gz"
    #endif
}

func installPath(version: String) -> URL {
    #if os(macOS)
    
    return FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("Library/Developer/Toolchains/\(version).xctoolchain")
    #elseif os(Linux)
    let toolchainsPath = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent(".toolchains")
    return toolchainsPath.appendingPathComponent("\(version)")
    #endif
}

func exec(_ arguments: [String]) {
    let process = Process()
    process.launchPath = "/bin/sh"
    process.arguments = ["-c", arguments.joined(separator: " ")]
    process.launch()
    process.waitUntilExit()
}

let downloadsPath = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appendingPathComponent(".tmp")

func downloadToolchain(version: String, completion: @escaping (URL) -> Void) {
    let installDir = installPath(version: version)
    guard !FileManager.default.fileExists(atPath: installDir.path) else {
        completion(installDir)
        return
    }
    let suffix = hostSuffix()
    let fileName = "\(version)-\(suffix)"
    let releaseURL = URL(string: "https://api.github.com/repos/swiftwasm/swift/releases/tags/\(version)/\(fileName)")!
    URLSession.shared.dataTask(with: releaseURL) { (data, _, error) in
        guard let data = data, error == nil else {
            fatalError("unexpected error: \(error!)")
        }
        let pkgPath = downloadsPath.appendingPathComponent(fileName)
        try! data.write(to: pkgPath)
        if pkgPath.path.hasSuffix(".pkg") {
            exec(["installer", "-pkg", pkgPath.path, "-target", "CurrentUserHomeDirectory"])
        } else if pkgPath.path.hasSuffix(".tar.gz") {
            exec(["tar", "xfz", pkgPath.path, "--strip-components=1",
                  "--directory", installDir.path])
        } else {
            fatalError("unknown toolchain package format")
        }
        completion(installDir)
    }
}

func waitForAll(_ completions: [() -> Void]) {
    let semaphore = DispatchSemaphore(value: 0)
    for completion in completions {
        completion()
        semaphore.signal()
    }
    for _ in completions {
        semaphore.wait()
    }
}

func downloadToolchains() -> [String: URL] {
    var result: [String: URL] = [:]
    var awaits: [() -> Void] = []
    for version in toolchainVersions {
        awaits.append {
            downloadToolchain(version: version) { installDir in
                result[version] = installDir
            }
        }
    }
    waitForAll(awaits)
    return result
}
