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
public typealias OnValueChangeCallback<T> = (T) -> Void
public typealias OnValueChangeAsyncCallback<T> = (T) async -> Void
public typealias OnValueChangeAsyncThrowCallback<T> = (T) async throws -> Void
