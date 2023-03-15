//
//  DefaultAlertView.swift
//  Cinder
//
//  Created by TriBQ on 29/08/2022.
//

import SwiftUI

public struct DefaultChoiceAlertView: View {
    public init(isShowing: Binding<Bool>,
                image: Image,
                title: String,
                titleFont: Font = .system(size: 16),
                description: String,
                descriptionFont: Font = .system(size: 12),
                confirmTitle: String = "Yes",
                cancelTitle: String = "No",
                buttonFont: Font = .system(size: 14),
                backgroundColor: Color = .white,
                foregroundColor: Color = .black,
                onConfirmTap: @escaping () -> Void,
                onCancelTap: (() -> Void)? = nil) {
        self._isShowing = isShowing
        self.image = image
        self.title = title
        self.description = description
        self.onConfirmTap = onConfirmTap
        self.onCancelTap = onCancelTap
        self.cancelTitle = cancelTitle
        self.confirmTitle = confirmTitle
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
    let confirmTitle: String
    let cancelTitle: String
    let buttonFont: Font
    let onConfirmTap: () -> Void
    let onCancelTap: (() -> Void)?
    let backgroundColor: Color
    let foregroundColor: Color
    
    public var body: some View {
        VStack(spacing: 0) {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
                .padding(.bottom, 16)
                .padding(.top, 20)
            
            Text(title)
                .font(titleFont)
                .padding(.bottom, 5)
            
            Text(description)
                .font(descriptionFont)
                .padding(.bottom, 23)
            
            Divider()
            
            HStack(spacing: 0) {
                Button(action: {
                    isShowing.toggle()
                    onCancelTap?()
                },
                       label: {
                    Text(cancelTitle)
                        .font(buttonFont)
                        .frame(maxWidth: .infinity)
                })
                
                Divider()
                
                Button(action: {
                    isShowing.toggle()
                    onConfirmTap()
                },
                       label: {
                    Text(confirmTitle)
                        .font(buttonFont)
                        .frame(maxWidth: .infinity)
                    
                })
            }
            .frame(height: 44)
        }
        .frame(minWidth: 200, maxWidth: 300)
        .foregroundColor(foregroundColor)
        .background(backgroundColor
            .clipShape(RoundedRectangle(cornerRadius: 14)))
    }
}
