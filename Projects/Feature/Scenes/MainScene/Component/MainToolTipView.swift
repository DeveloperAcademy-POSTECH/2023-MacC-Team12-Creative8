//
//  MainToolTip.swift
//  Feature
//
//  Created by 최효원 on 7/31/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI

struct MainTooltipView: View {
  var body: some View {
    ZStack(alignment: .topTrailing) {
      CustomTriangleShape()
        .fill(Color.mainOrange)
        .offset(x: -50, y: 3)
        .frame(width: 20, height: 50)
      
      CustomRectangleShape(text: "메인 화면 아티스트를 수정할 수 있어요")
        .frame(width: 250, height: 40)

    }
  }
}

private struct CustomTriangleShape: Shape {
    private var width: CGFloat
    private var height: CGFloat
    private var radius: CGFloat
    
    fileprivate init(
        width: CGFloat = 20,
        height: CGFloat = 20,
        radius: CGFloat = 1
    ) {
        self.width = width
        self.height = height
        self.radius = radius
    }
    
    fileprivate func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let topCenter = CGPoint(x: rect.minX + width / 2, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.minY + height)
        let bottomRight = CGPoint(x: rect.minX + width, y: rect.minY + height)
        
        path.move(to: CGPoint(x: topCenter.x - radius, y: rect.minY))
        path.addArc(
            center: CGPoint(x: topCenter.x, y: rect.minY + radius),
            radius: radius,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 0),
            clockwise: false
        )
        
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.closeSubpath()
        
        return path
    }
}

private struct CustomRectangleShape: View {
    private var text: LocalizedStringKey
    
    fileprivate init(text: LocalizedStringKey) {
        self.text = text
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            Text(text)
                .font(.footnote)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 18)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.mainOrange)
                )
        }
    }
}

#Preview {
  MainTooltipView()
}
