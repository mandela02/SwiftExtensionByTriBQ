//
//  Encodable+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/08/2022.
//

import Foundation

public extension Encodable {
    func toJSONString(toSnakeCase: Bool = false) -> String? {
        let encoder = JSONEncoder()
        if toSnakeCase { encoder.keyEncodingStrategy = .convertToSnakeCase }
        guard let jsonData = try? encoder.encode(self) else { return nil }
        return jsonData.asString
    }

    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else { return nil }
        return dictionary
    }
}
