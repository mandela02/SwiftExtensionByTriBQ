//
//  BaseNavigationBarView.swift
//  Cinder
//
//  Created by TriBQ on 28/08/2022.
//

import Foundation
import SwiftUI

public struct BaseNavigationBarView: View {
    public init(title: String,
                backButtonImage: Image = Image(systemName: "chevron.left"),
                font: Font = .system(size: 20),
                foregroundColor: Color = .black,
                onBack: (() -> Void)? = nil) {
        self.title = title
        self.onBack = onBack
        self.backButtonImage = backButtonImage
        
        self.font = font
        self.foregroundColor = foregroundColor
    }
    
    let title: String
    let onBack: (() -> Void)?
    let backButtonImage: Image
    
    let font: Font
    let foregroundColor: Color
    
    private var isHavingBackButton: Bool {
        return onBack != nil
    }
    
    public var body: some View {
        HStack {
            if let onBack = onBack {
                Button(action: onBack, label: {
                    ZStack(alignment: .leading) {
                        Color.black.opacity(0.0001)
                        HStack {
                            backButtonImage
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18, alignment: .leading)
                            Spacer()
                        }
                    }
                })
                .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            Text(title)
                .font(font)
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
                .padding(.horizontal, 10)
            
            Spacer()
            
            if isHavingBackButton {
                Color.clear
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 22)
        .foregroundColor(foregroundColor)
        .frame(height: 44)
    }
}
