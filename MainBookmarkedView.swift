//
//  MainBookmarkedView.swift
//  Feature
//
//  Created by 장수민 on 10/11/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

public struct MainBookmarkedView: View, Identifiable, Hashable {
    public var id: Int
    let destination: AnyView
    public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    public static func == (lhs: MainBookmarkedView, rhs: MainBookmarkedView) -> Bool {
            lhs.id == rhs.id
        }
    var bookmarkData: MainBookmarkData
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height

    public var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 0) {
                Image("postmalone")
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth * 0.84
                           ,height: (screenHeight * 0.28)
                    )
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(11)
                    .padding(.bottom)
                    .overlay(
                        HStack {
                            VStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 110)
                                    .frame(width: screenWidth * 0.56, height: screenHeight * 0.15)
                                    .rotationEffect(Angle(degrees: 15))
                                    .offset(x: -(screenWidth * 0.06))
                                    .foregroundColor(.gray)
                            }
                            VStack {
                                RoundedRectangle(cornerRadius: 110)
                                    .frame(width: screenWidth * 0.56, height: screenHeight * 0.15)
                                    .offset(x: screenWidth * 0.06, y: -(screenHeight * 0.01))
                                    .rotationEffect(Angle(degrees: 15))
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                    )
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                VStack {
                                    Text(bookmarkData.month)
                                    Text(bookmarkData.day)
                                        .font(.largeTitle)
                                        .bold()
                                }
                                .padding(.top, 10)
                                .padding(.trailing, 35)
                            }
                            Spacer()
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: 70, maxHeight: 40)
                                        .overlay(
                                            Text(bookmarkData.dDay)
                                        )
                                }
                                .padding(.top)
                                Spacer()
                            }
                        }
                            .padding()
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text(bookmarkData.singer)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding([.leading, .bottom])
                Text(bookmarkData.concertName)
                    .padding(.leading)
                    .padding(.bottom, 28)
            }
            .foregroundStyle(.black)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray)
        )
        }
        .buttonStyle(BookMarkViewButton())
    }
}
struct BookMarkViewButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
  }
}

#Preview {
    MainBookmarkedView(id: 0, destination: AnyView(Text("해당 아티스트로 연결")), bookmarkData: MainBookmarkData(id: 0))
}
