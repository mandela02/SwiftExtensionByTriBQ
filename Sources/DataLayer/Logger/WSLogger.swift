//
//  WSLogger.swift
//  DASwiftExtension
//
//  Created by TriBQ on 12/2/25.
//


struct WSLogger {
    static func log(_ message: String) {
#if DEBUG
        print("\n[WebSocket] - \(message)\n")
#endif
    }
}
