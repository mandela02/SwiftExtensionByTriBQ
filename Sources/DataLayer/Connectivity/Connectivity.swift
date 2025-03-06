//
//  Connectivity.swift
//  DataLayer
//
//  Created by Tri Bui Q. VN.Hanoi on 07/12/2022.
//

import Foundation
import Alamofire

actor Connectivity {
    public static let shared = Connectivity()
    private init() { }
    let sharedInstance = NetworkReachabilityManager()

    var isConnectedToInternet: Bool {
        if let sharedInstance = sharedInstance {
            return sharedInstance.isReachable
        }
        return false
    }
}
