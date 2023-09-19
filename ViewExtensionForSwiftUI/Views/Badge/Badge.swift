//
//  Badge.swift
//  Cinder
//
//  Created by TriBQ on 04/09/2022.
//

import SwiftUI

public struct Badge: View {
    let count: Int?
    let font: Font
    let backgroundColor: Color
    let foregroundColor: Color
    
    var isOneDigit: Bool {
        guard let count = count else {
            return false
        }

        return count >= 0 && count < 10
    }
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            if let count = count {
                Text(String(count))
                    .font(font)
                    .lineLimit(1)
                    .padding(.horizontal, isOneDigit ? .leastNonzeroMagnitude : 4)
                    .background(
                        backgroundColor
                        .frame(height: 14)
                        .frame(width: isOneDigit ? 14 : nil)
                        .cornerRadius(14 / 2))
                    .foregroundColor(foregroundColor)
                    .alignmentGuide(.top) { $0[.bottom] }
                    .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.25 }
            }
        }
    }
}
