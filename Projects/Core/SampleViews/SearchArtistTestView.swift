//
//  SearchArtistTestView.swift
//  Core
//
//  Created by 고혜지 on 10/10/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct SearchArtistTestView: View {
    
    let dataService: DataService = DataService.shared
    let koreanNameConverter: KoreanNameConverter = KoreanNameConverter.shared

    @State private var isLoading: Bool = false
    @State private var textFieldText: String = ""
    @State private var artistList: [MusicBrainzArtist] = []
    @State private var showArtistList: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                textField
                    .onChange(of: textFieldText) { oldValue, newValue in
                        isLoading = true
                        dataService.searchArtistsFromMusicBrainz(artistName: textFieldText) { result in
                            if let result = result {
                                DispatchQueue.main.async {
                                    artistList = result.artists ?? []
                                    isLoading = false
                                }
                            } else {
                                print("Failed to fetch setlist data.")
                            }
                        }
                        showArtistList = true
                        if newValue == "" {
                            showArtistList = false
                        }
                    }

                if showArtistList {
                    if isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        artistsList
                    }
                }
            }
            Spacer()
        }
    }
    
}

extension SearchArtistTestView {
    
    private var textField: some View {
        TextField("add artist name here...", text: $textFieldText)
            .font(.headline)
            .padding(.leading)
            .frame(height: 55)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)
    }
    
    private var artistsList: some View {
        ForEach(artistList.prefix(10), id: \.name) { artist in
            List {
                NavigationLink {
                    VStack {
                        Text("name: \(koreanNameConverter.findKoreanName(artist: artist))")
                        Text("gender: \(artist.gender ?? "")")
                        Text("country: \(artist.country ?? "")")
                    }
                    .navigationTitle("Artist Info")
                } label: {
                    VStack(alignment: .leading) {
                        Text(koreanNameConverter.findKoreanName(artist: artist))
                            .font(.headline)
                        Text(artist.id ?? "")
                            .font(.subheadline)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
}

#Preview {
    SearchArtistTestView()
}
