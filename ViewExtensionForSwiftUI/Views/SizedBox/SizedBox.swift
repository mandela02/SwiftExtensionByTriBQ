//
//  SizedBox.swift
//  Cinder
//
//  Created by TriBQ on 28/08/2022.
//

import SwiftUI

public struct SizedBox: View {
    public init(width: CGFloat? = nil,
         height: CGFloat? = nil,
         maxWidth: CGFloat? = nil,
         maxHeight: CGFloat? = nil) {
        self.width = width
        self.height = height
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
        
    let width: CGFloat?
    let height: CGFloat?
    let maxWidth: CGFloat?
    let maxHeight: CGFloat?

    public var body: some View {
        Color.clear
            .frame(width: width, height: height)
            .frame(maxWidth: maxWidth, maxHeight: maxHeight)
    }
}
