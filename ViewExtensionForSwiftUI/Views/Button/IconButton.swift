//
//  IconButton.swift
//  Cinder
//
//  Created by TriBQ on 04/09/2022.
//

import Foundation
import SwiftUI

public struct IconButton: View {
    public init(icon: Image,
                size: CGSize = CGSize(width: 16, height: 16),
                action: @escaping () -> Void) {
        self.icon = icon
        self.size = size
        self.action = action
    }
    
    let icon: Image
    let size: CGSize
    let action: () -> Void
    
    public var body: some View {
        Button(action: action,
               label: {
            ZStack {
                Color.black.opacity(0.00001)
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
        })
        .frame(width: size.width, height: size.height, alignment: .center)
    }
}
