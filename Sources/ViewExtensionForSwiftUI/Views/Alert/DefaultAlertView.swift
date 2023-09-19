//
//  File.swift
//  
//
//  Created by TriBQ on 04/09/2022.
//

import SwiftUI

public struct DefaultAlertView: View {
    public init(isShowing: Binding<Bool>,
                image: Image,
                title: String,
                titleFont: Font = .system(size: 16),
                description: String,
                descriptionFont: Font = .system(size: 12),
                cancelTitle: String = "Cancel",
                buttonFont: Font = .system(size: 14),
                backgroundColor: Color = .white,
                foregroundColor: Color = .black,
                onCancelTap: (() -> Void)? = nil) {
        self._isShowing = isShowing
        self.image = image
        self.title = title
        self.description = description
        self.onCancelTap = onCancelTap
        self.cancelTitle = cancelTitle
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        
        self.titleFont = titleFont
        self.descriptionFont = descriptionFont
        self.buttonFont = buttonFont
    }
    
    @Binding
    var isShowing: Bool
    
    let image: Image
    let title: String
    let titleFont: Font
    let description: String
    let descriptionFont: Font
    let cancelTitle: String
    let buttonFont: Font
    let onCancelTap: (() -> Void)?
    let backgroundColor: Color
    let foregroundColor: Color
    
    public var body: some View {
        VStack(spacing: 0) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .padding(.bottom, 16)
                .padding(.top, 20)
            
            Text(title)
                .font(titleFont)
                .padding(.bottom, 5)
            
            Text(description)
                .font(descriptionFont)
                .padding(.bottom, 23)
                .padding(.horizontal, 20)
            
            Divider()
            
            Button(action: {
                isShowing.toggle()
                onCancelTap?()
            },
                   label: {
                Text(cancelTitle)
                    .font(buttonFont)
                    .frame(maxWidth: .infinity)
            })
            .frame(height: 44)
        }
        .frame(minWidth: 200, maxWidth: 300)
        .foregroundColor(foregroundColor)
        .background(backgroundColor
            .clipShape(RoundedRectangle(cornerRadius: 14)))
        .padding(.horizontal, 20)
    }
}
