//
//  File.swift
//  
//
//  Created by TriBQ on 04/09/2022.
//

import SwiftUI

public extension Font {
    init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
