//
//  File.swift
//  
//
//  Created by Tri Bui Q. VN.Hanoi on 16/02/2023.
//

import Foundation

public typealias VoidCallback = () -> Void
public typealias AsyncVoidCallback = () async -> Void
public typealias AsyncThrowVoidCallback = () async throws -> Void
public typealias AsyncThrowValueCallback<T> = (T) async throws -> Void
public typealias OnValueChange<T> = (T) -> Void
