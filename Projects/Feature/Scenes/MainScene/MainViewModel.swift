//
//  MainViewModel.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var mainBookMarkData: MainBookMarkData
    @Published var popArtistData: PopularArtistData

    init(mainBookMarkData: MainBookMarkData, popArtistData: PopularArtistData) {
           self.mainBookMarkData = mainBookMarkData
           self.popArtistData = popArtistData
       }
}
