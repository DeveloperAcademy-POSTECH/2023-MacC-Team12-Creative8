//
//  ArtistImageAndConcertListView.swift
//  Feature
//
//  Created by 장수민 on 11/17/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData
import Core
import UI
import Combine

struct ArtistsContentView: View {
  @Binding var selectedTab: Tab
  @StateObject var viewModel: MainViewModel
  @State var artistInfo: SaveArtistInfo
  @StateObject var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  @State private var navigateToArtistView = false

  var index: Int
  var body: some View {
    VStack(spacing: 24) {
      artistImage
      Group {
        if !viewModel.isLoading {
          Group {
            bothExistLayer
              .frame(width: UIWidth * 0.92)
          }
          .padding(.horizontal, 3)
          .scrollTransition(.animated.threshold(.visible(0.5))) { content, phase in
            content
              .opacity(phase.isIdentity ? 1 : 0)
              .blur(radius: phase.isIdentity ? 0 : 0.5)
          }
        } else {
          ProgressView()
            .frame(width: UIWidth, height: UIWidth * 0.6) 
        }
      }
    
    NavigationLink(destination: ArtistView(
                   selectedTab: $selectedTab,
                   artistName: artistInfo.name,
                   artistAlias: artistInfo.alias,
                   artistMbid: artistInfo.mbid
               ), isActive: $navigateToArtistView) {
                   EmptyView()
               }
           }
    .frame(width: UIWidth * 0.81)
    .onAppear {
      dataManager.modelContext = modelContext
    }
  }
  private var artistImage: some View {
    NavigationLink(value: NavigationDelivery(artistInfo: artistInfo)) {
      ArtistImage(selectedTab: $selectedTab, imageUrl: artistInfo.imageUrl)
        .frame(width: UIWidth * 0.81, height: UIWidth * 0.81)
    }
    .buttonStyle(BasicButtonStyle())
  }
  
  private var bothExistLayer: some View {
    let setlists: [Setlist?] = viewModel.setlists[index] ?? []
    
    if let firstSetlist = setlists.first {
      
      let venueName = firstSetlist?.venue?.name ?? ""
      let city = firstSetlist?.venue?.city?.name ?? ""
      let countryName = firstSetlist?.venue?.city?.country?.name ?? ""
      let artistName = firstSetlist?.artist?.name ?? ""
      
      return SummarizedSetlistInfoView(
        type: .recentConcert,
        info: SetlistInfo(
          artistInfo: artistInfo.toArtistInfo(),
          id: firstSetlist?.id ?? "",
          date: viewModel.getDateFormatted(dateString: firstSetlist?.eventDate ?? ""),
          title: firstSetlist?.tour?.name ?? "\(artistName) Setlist",
          venue: "\(venueName)\n\(city),\(countryName)"
        ),
        infoButtonAction: nil,
        cancelBookmarkAction: nil,
        chevronButtonAction: {
          navigateToArtistView = true 

        }
      )
    } else {
      return SummarizedSetlistInfoView(
        type: .recentConcert,
        info: nil,
        infoButtonAction: nil,
        cancelBookmarkAction: nil,
        chevronButtonAction: nil
      )
    }
  }
}
