//
//  MainBookmarkedView.swift
//  Feature
//
//  Created by 장수민 on 10/11/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct MainBookmarkedView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let archivedNum: Int = 4
    let singer: String = "Post Malone"
    let concertName: String = "If Ya’ll Weren’t Here, I’d Be Crying"
    let dDay: String = "D-20"
    let month: String = "10월"
    let day: String = "27"
    let image: String = "postmalone"
    @State private var scrollID: Int?
    var body: some View {
        ScrollView(.horizontal) {
            VStack {
                LazyHStack(spacing: 6) {
                    ForEach(0..<archivedNum, id: \.self) { _ in
                        VStack(alignment: .leading, spacing: 0) {
                            Image("postmalone")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaledToFit()
                                .frame(width: screenWidth * 0.92)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(11)
                                .padding(.bottom)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 110)
                                    .frame(width: 220, height: 120)
                                    .rotationEffect(Angle(degrees: 15))
                                    .offset(x: 140, y: -75) // 빼고 패딩이랑 스페이서
                                    .foregroundColor(.gray)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 110)
                                    .frame(width: 220, height: 120)
                                    .rotationEffect(Angle(degrees: 15))
                                    .offset(x: -140, y: 75)
                                    .foregroundColor(.gray)
                                )
                                .overlay(
                                    VStack {
                                        HStack {
                                            Spacer()
                                            VStack {
                                                Text(month)
                                                Text(day)
                                                    .font(.largeTitle)
                                                    .bold()
                                            }
                                            .padding()
                                            .padding(.trailing)
                                        }
                                        Spacer()
                                        HStack {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: 70, maxHeight: 40)
                                                    .overlay(
                                                    Text(dDay)
                                                    )
                                            }
                                            .padding(.top)
                                            Spacer()
                                        }
                                    }
                                    .padding()
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            Text(singer)
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.leading)
                                .padding(.bottom)
                        
                            Text(concertName)
                                .padding(.bottom)
                                .padding(.leading)
                            Text("")
                        }
                        .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.gray)
                        )
                        .padding(.horizontal, 6)
                    }
                }
                .scrollTargetLayout()
                .safeAreaPadding(.horizontal, 14)
            }
        }
        .onAppear{
            if archivedNum != 0 {
                scrollID = 0
            }
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.never)
        .scrollPosition(id: $scrollID)
        HStack(spacing: 8) {
            ForEach(0..<archivedNum, id: \.self) { pageIndex in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(scrollID == pageIndex ? .black : .gray)
                    .animation(.easeInOut(duration: 0.3))
                    .onTapGesture {
                        withAnimation {
                            scrollID = pageIndex
                        }
                    }
            }
            .padding(.vertical, 18)
        }
    }
}

#Preview {
    MainBookmarkedView()
}
