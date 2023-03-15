//
//  Dictionary+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/08/2022.
//

import Foundation

public extension Dictionary where Key: Codable, Value: Codable {
    func toJSONString() -> String? {
        guard let jsonData = try? JSONEncoder().encode(self) else { return nil }
        return jsonData.asString
    }
}
