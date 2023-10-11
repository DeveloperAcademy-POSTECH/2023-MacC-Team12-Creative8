//
//  PopularArtistView.swift
//  Feature
//
//  Created by 장수민 on 10/11/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct PopularArtistsView: View {
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
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 172)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
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
                        HStack {
                            VStack {
                                Text(month1)
                                    .font(.caption)
                                Text(day1)
                                    .font(.title3)
                            }
                            .padding(.trailing, 10)
                            Text(venue1)
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                    }
                    .padding(.vertical, 15)
                }
                .frame(maxWidth: 172)
                VStack {
                    RoundedRectangle(cornerRadius: 17)
                        .overlay(
                            HStack {
                                VStack {
                                    Text(month2)
                                        .font(.caption)
                                    Text(day2)
                                        .font(.title3)
                                }
                                .padding(.trailing, 10)
                                Text(.init(venue2))
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            .padding(12)
                        )
                    RoundedRectangle(cornerRadius: 17)
                        .overlay(
                            HStack {
                                VStack {
                                    Text(month3)
                                        .font(.caption)
                                    Text(day3)
                                        .font(.title3)
                                }
                                .padding(.trailing, 10)
                                Text(.init(venue3))
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            .padding(12)
                        )
                }
                }
            .frame(height: 132)
        }
    }
}

#Preview {
    PopularArtistsView(singer: "블랙핑크", image: "bts", day1: "02", month1: "11월", venue1: "KINTEX, Goyang-si,South Korea", day2: "02", month2: "11월", venue2: "KINTEX, Goyang-si, South Korea", day3: "02", month3: "11월", venue3: "KINTEX, Goyang-si,South Korea")
}
