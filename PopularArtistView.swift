//
//  PopularArtistView.swift
//  Feature
//
//  Created by 장수민 on 10/11/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//
import SwiftUI

public struct PopularArtistsView: View {
    @ObservedObject var viewModel: PopularArtistViewModel

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    public var body: some View {
        VStack {
            HStack {
                ZStack {
                    Image(viewModel.popArtistData.image)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: screenWidth * 0.44, height: screenHeight * 0.16)
                            
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.2), Color.black]),
                                       startPoint: .top,
                                       endPoint: .bottom)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    VStack {
                        Text(viewModel.popArtistData.singer)
                                .foregroundColor(.white)
                                .font(.callout)
                            .bold()
                            .padding(.top)
                        Spacer()
                        PopArtistBlockView(month: viewModel.popArtistData.month1, day: viewModel.popArtistData.day1, venue: viewModel.popArtistData.venue1)
                    }
                    .padding(.vertical, 15)
                }
                .frame(width: screenWidth * 0.44)
                VStack {
                    RoundedRectangle(cornerRadius: 17)
                        .overlay(
                            PopArtistBlockView(month: viewModel.popArtistData.month2, day: viewModel.popArtistData.day2, venue: viewModel.popArtistData.venue2)
                            .padding(12)
                        )
                    RoundedRectangle(cornerRadius: 17)
                        .overlay(
                            PopArtistBlockView(month: viewModel.popArtistData.month3, day: viewModel.popArtistData.day3, venue: viewModel.popArtistData.venue3)
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
                Text(venue)
                    .font(.caption)
            }
            .foregroundColor(.white)
        }
    }
}

#Preview {
    PopularArtistsView(viewModel: PopularArtistViewModel(popArtistData: PopularArtistData()))
}
