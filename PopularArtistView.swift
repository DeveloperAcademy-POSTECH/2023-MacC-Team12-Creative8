//
//  PopularArtistView.swift
//  Feature
//
//  Created by 장수민 on 10/11/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//
import SwiftUI

public struct PopularArtistsView: View {
    var popularArtistData: PopularArtistData
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    public var body: some View {
        VStack {
            HStack {
                ZStack {
                    imageView
                    gradientView
                    overlayTextView
                }
                .frame(width: screenWidth * 0.44)
                VStack {
                    topRectangle
                    bottomRectangle
                }
            }
            .frame(height: screenHeight * 0.16)
        }
    }
    var imageView: some View {
        Image(popularArtistData.image)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(width: screenWidth * 0.44, height: screenHeight * 0.16)
    }
    var gradientView: some View {
        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.2), Color.black]),
                       startPoint: .top,
                       endPoint: .bottom)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    var topRectangle: some View {
        RoundedRectangle(cornerRadius: 17)
            .overlay(
                PopArtistBlockView(month: popularArtistData.month2, day: popularArtistData.day2, venue: popularArtistData.venue2)
                    .padding(12)
            )
    }
    var bottomRectangle: some View {
        RoundedRectangle(cornerRadius: 17)
            .overlay(
                PopArtistBlockView(month: popularArtistData.month3, day: popularArtistData.day3, venue: popularArtistData.venue3)
                    .padding(12)
            )
    }
    var overlayTextView: some View {
        VStack {
            Text(popularArtistData.singer)
                .foregroundColor(.white)
                .font(.callout)
                .bold()
                .padding(.top)
            Spacer()
            PopArtistBlockView(month: popularArtistData.month1, day: popularArtistData.day1, venue: popularArtistData.venue1)
                .padding(.leading, 15)
                .padding(.trailing, 9)
        }
        .padding(.vertical, 15)
    }
    struct PopArtistBlockView: View {
        let month: String
        let day: String
        let venue: String
        var body: some View {
            HStack {
                VStack {
                    Text(.init(month))
                        .font(.caption)
                    Text(.init(day))
                        .font(.title3)
                }
                Spacer()
                    .padding(.trailing, 10)
                Text(.init(venue))
                    .font(.caption)
            }
            .foregroundColor(.white)
        }
    }
}

#Preview {
    PopularArtistsView(popularArtistData: PopularArtistData())
}
