//
//  SegmentedControlView.swift
//  Cinder
//
//  Created by TriBQ on 04/09/2022.
//

import SwiftUI

public struct SegmentControlView: View {

    @Binding private var selection: Int?
    @State private var segmentSize: CGSize = .zero

    private let items: [String]
    private let spacing: CGFloat
    private let font: UIFont
    private let textColor: Color
    private let selectedTextColor: Color
    private let bottomLineColor: Color
    
    private let isAllowNullValue: Bool

    public init(items: [String],
                spacing: CGFloat,
                font: UIFont?,
                textColor: Color = .white,
                selectedTextColor: Color = .blue,
                bottomLineColor: Color = .black,
                selection: Binding<Int?>,
                isAllowNullValue: Bool) {
        self._selection = selection
        self.items = items
        self.font = font ?? .systemFont(ofSize: 16)
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.bottomLineColor = bottomLineColor
        self.spacing = spacing
        self.isAllowNullValue = isAllowNullValue
    }
    
    public var body: some View {
        ScrollView(.horizontal,
                   showsIndicators: false) {
            VStack(alignment: .leading) {
                HStack(spacing: spacing) {
                    ForEach(items.indices, id: \.self) { index in
                        let text = items[index]
                        let width = text.widthOfString(usingFont: font)
                        
                        Text(items[index])
                            .font(Font(uiFont: font))
                            .foregroundColor(self.selection == index ? selectedTextColor : textColor)
                            .onTapGesture { onItemTap(index: index) }
                            .frame(width: width)
                    }
                }
                Rectangle()
                    .foregroundColor(bottomLineColor)
                    .frame(width: selectedItemWidth, height: 3, alignment: .leading)
                    .offset(x: offsetX, y: 0)
                    .animation(Animation.linear(duration: 0.3), value: selection)
            }
        }
    }

    private var selectedItemWidth: CGFloat {
        if items.isEmpty { return .leastNonzeroMagnitude }
        if let selection = selection {
            return items[selection].widthOfString(usingFont: font)
        } else {
            return .leastNonzeroMagnitude
        }
    }
    
    private var offsetX: CGFloat {
        if items.isEmpty { return .leastNonzeroMagnitude }
        if selection == 0 { return .leastNonzeroMagnitude }
        
        if let selection = selection {
            let offset = items[0..<selection].map { $0.widthOfString(usingFont: font) }
                .reduce(0, +) + spacing * CGFloat(selection)
            
            return offset
        }
        
        return .leastNonzeroMagnitude
    }

    private func onItemTap(index: Int) {
        guard index < self.items.count else { return }
        if isAllowNullValue {
            if index == self.selection {
                self.selection = nil
            } else {
                self.selection = index
            }
        } else {
            self.selection = index
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    public typealias Value = CGSize
    public static var defaultValue: Value = .zero

    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct BackgroundGeometryReader: View {
    public init() {}

    public var body: some View {
        GeometryReader { geometry in
            return Color
                    .clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}


extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
         let fontAttributes = [NSAttributedString.Key.font: font]
         let size = self.size(withAttributes: fontAttributes)
         return size.width
     }
}

extension Font {
    init(uiFont: UIFont) {
    self = Font(uiFont as CTFont)
  }
}
