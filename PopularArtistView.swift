//
//  PopularArtistView.swift
//  Feature
//
//  Created by 장수민 on 10/11/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

public struct PopularArtistsView: View {
    let singer: String
    let image: String
    let day1: String
    let month1: String
    let venue1: String
    let day2: String
    let month2: String
    let venue2: String
    let day3: String
    let month3: String
    let venue3: String
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    public var body: some View {
        VStack {
            HStack {
                ZStack {
                        Image(image)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: screenWidth * 0.44, height: screenHeight * 0.16)
                            
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.2), Color.black]),
                                       startPoint: .top,
                                       endPoint: .bottom)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    VStack {
                        Text(singer)
                                .foregroundColor(.white)
                                .font(.callout)
                            .bold()
                            .padding(.top)
                        Spacer()
                        PopArtistBlockView(month: month1, day: day1, venue: venue1)
                    }
                    .padding(.vertical, 15)
                }
                .frame(width: screenWidth * 0.44)
                VStack {
                    RoundedRectangle(cornerRadius: 17)
                        .overlay(
                            PopArtistBlockView(month: month2, day: day2, venue: venue2)
                            .padding(12)
                        )
                    RoundedRectangle(cornerRadius: 17)
                        .overlay(
                            PopArtistBlockView(month: month3, day: day3, venue: venue3)
                            .padding(12)
                        )
                    }
                }
            .frame(height: screenHeight * 0.16)
        }
    }
    struct PopArtistBlockView: View {
        let month: String
        let day: String
        let venue: String
        var body: some View {
            HStack {
                VStack {
                    Text(month)
                        .font(.caption)
                    Text(day)
                        .font(.title3)
                }
                .padding(.trailing, 10)
                Text(.init(venue))
                    .font(.caption)
            }
            .foregroundColor(.white)
        }
    }
}

#Preview {
    PopularArtistsView(singer: "블랙핑크", image: "bts", day1: "02", month1: "11월", venue1: "KINTEX, Goyang-si,South Korea", day2: "02", month2: "11월", venue2: "KINTEX, Goyang-si, South Korea", day3: "02", month3: "11월", venue3: "KINTEX, Goyang-si,South Korea")
}
