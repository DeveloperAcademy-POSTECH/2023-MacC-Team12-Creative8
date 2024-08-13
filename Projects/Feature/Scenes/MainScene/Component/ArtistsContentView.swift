//
//  ArtistImageAndConcertListView.swift
//  Feature
//
//  Created by 장수민 on 11/17/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//
import SwiftUI
import Core
import SwiftData

struct ArtistsContentView: View {
    @Binding var selectedTab: Tab
    @StateObject var viewModel: MainViewModel
    @State var artistInfo: SaveArtistInfo
    @StateObject var dataManager = SwiftDataManager()
    @Environment(\.modelContext) var modelContext
    @Query(sort: \LikeArtist.orderIndex, order: .reverse) var likeArtists: [LikeArtist]
    @StateObject var tabViewManager: TabViewManager
    
    var index: Int
    
    var body: some View {
        let setlists: [Setlist?] = viewModel.setlists[index] ?? []
        
        NavigationStack(path: $tabViewManager.pageStack) {
            VStack(spacing: 24) {
                
                if viewModel.isLoading {
                    loadingView
                } else {
                    if let firstSetlist = setlists.compactMap({ $0 }).first {
                            VStack(spacing: 12) {
                                summarizedSetlistView(for: firstSetlist)
                                ArtistMainSetlistView(viewModel: viewModel, index: index)
                            }
                                            
                    } else {
                        emptySetlistView
                    }
                }
            }
            .onAppear {
                dataManager.modelContext = modelContext
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView()
    }
    
    private var emptySetlistView: some View {
        SummarizedSetlistInfoView(
            type: .recentConcert,
            info: nil,
            infoButtonAction: nil,
            chevronButtonAction: nil
        )
    }
    
    private func summarizedSetlistView(for setlist: Setlist) -> some View {
        let venueName = setlist.venue?.name ?? ""
        let city = setlist.venue?.city?.name ?? ""
        let countryName = setlist.venue?.city?.country?.name ?? ""
        let artistName = setlist.artist?.name ?? ""
        
        return SummarizedSetlistInfoView(
            type: .recentConcert,
            info: SetlistInfo(
                artistInfo: artistInfo.toArtistInfo(),
                id: setlist.id ?? "",
                date: viewModel.getDateFormatted(dateString: setlist.eventDate ?? ""),
                title: setlist.tour?.name ?? "\(artistName) Setlist",
                venue: "\(venueName)\n\(city), \(countryName)"
            ),
            infoButtonAction: nil,
            chevronButtonAction: {
                viewModel.navigateToArtistView = true
            }
        )
    }
}
