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
    let screenHeight = UIScreen.main.bounds.size.height
    let archivedNum: Int
    let singer: String
    let concertName: String
    let dDay: String
    let month: String
    let day: String
    let image: String

    @State private var scrollID: Int?
    var body: some View {
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
        }
    }

#Preview {
    MainBookmarkedView(archivedNum: 4, singer: "Post Malone", concertName: "conecert", dDay: "D-1", month: "10", day: "27", image: "post malone")
}
