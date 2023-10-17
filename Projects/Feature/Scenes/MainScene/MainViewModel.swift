//
//  MainViewModel.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import Foundation

class MainBookmarkViewModel: ObservableObject {
    @Published var mainBookmarksData: [MainBookmarkData] = []
        init() {
            mainBookmarksData = []
        }
}

class PopularArtistViewModel: ObservableObject {
    @Published var popArtistData: PopularArtistData = PopularArtistData()

    init(popArtistData: PopularArtistData) {
           self.popArtistData = popArtistData
       }
}
