//
//  Connectivity.swift
//  DataLayer
//
//  Created by Tri Bui Q. VN.Hanoi on 07/12/2022.
//

import Foundation
import Alamofire

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()
    
  static var isConnectedToInternet:Bool {
      if let sharedInstance = sharedInstance {
          return sharedInstance.isReachable
      }
      return false
    }
}

