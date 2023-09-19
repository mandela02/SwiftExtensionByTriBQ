//
//  IconWithTitleButton.swift
//  Cinder
//
//  Created by TriBQ on 04/09/2022.
//

import Foundation
import SwiftUI

public struct IconWithTitleButton: View {
    public init(title: String, font: Font, textColor: Color, icon: Image, iconSize: CGSize, iconColor: Color, backgroundColor: Color, cornerRadius: CGFloat, action: @escaping () -> Void) {
        self.title = title
        self.font = font
        self.textColor = textColor
        self.icon = icon
        self.iconSize = iconSize
        self.iconColor = iconColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    
    let title: String
    let font: Font
    let textColor: Color
    let icon: Image
    let iconSize: CGSize
    let iconColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let action: () -> Void

    public var body: some View {
        Button(action: action,
               label: {
            HStack(spacing: 5) {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize.width,
                           height: iconSize.height,
                           alignment: .center)
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(font)
                    .foregroundColor(textColor)
            }
            .padding(.vertical, 7)
            .padding(.horizontal, 13)
            .background(
                backgroundColor
                    .cornerRadius(cornerRadius)
            )
        })
    }

}
