//
//  FileManager+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/8/2022.
//

import Foundation

public extension FileManager {
    func clearTempDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            debugPrint("Error clearing tmp folder")
        }
    }
    
    func deleteFile(at filePath: URL) {
        do {
            if self.fileExists(atPath: filePath.path) {
                try self.removeItem(at: filePath)
            }
        } catch {
            debugPrint("Error delete file at: \(filePath)")
        }
    }
}
