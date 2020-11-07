#if canImport(FoundationXML)
  #error("FoundationXML should not be able to import now")
#endif

#if canImport(FoundationNetworking)
  #error("FoundationNetworking should not be able to import now")
#endif

#if canImport(Foundation)
#else
  #error("Foundation should be able to import")
#endif
