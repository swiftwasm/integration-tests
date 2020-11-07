import Foundation
import CoreFoundation
import XCTest
import WASILibc

#if canImport(FoundationXML)
  #error("FoundationXML should not be able to import now")
#endif

#if canImport(FoundationNetworking)
  #error("FoundationNetworking should not be able to import now")
#endif

public func main() {
  _ = Date()
  _ = UUID()
  _ = URL(string: "https://example.com")!
}