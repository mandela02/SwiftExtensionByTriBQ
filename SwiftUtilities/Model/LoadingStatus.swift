//
//  File.swift
//  
//
//  Created by TriBQ on 28/08/2022.
//

import Foundation

public enum LoadingStatus: Equatable {
    case initial
    case inProcess
    case success
    case error(String)
}
