//
//  SongListTestView.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct SongListTestView: View {
    let koreanTitleConverter: KoreanTitleConverter = KoreanTitleConverter.shared
    
    @State private var isLoading: Bool = false
    @State private var textFieldText: String = ""
    @State private var parsedSongList: [(String, String?)] = []
    
    var body: some View {
        VStack(spacing: 20) {
            textField
            
            Button(action: {
                isLoading = true
                let artistName = textFieldText
                textFieldText = ""
                koreanTitleConverter.getSongListByArtist(artistName: artistName) { result in
                    if let result = result {
                        parsedSongList = result
                        isLoading = false
                    } else  {
                        print("Failed to fetch setlist data.")
                    }
                }
            }, label: {
                Text("FIND")
                    .bold()
            })
            
            if isLoading {
                ProgressView()
            } else  {
                songList
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }

    var textField: some View {
        TextField("add artist name here...", text: $textFieldText)
            .font(.headline)
            .padding(.leading)
            .frame(height: 55)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)
    }
    
    var songList: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(Array(parsedSongList.enumerated()), id: \.offset) { index, song in
                    HStack {
                        Text("\(index + 1). ")
                        Text("\(song.0)")
                        if let second = song.1 {
                            Text("\(second)")
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                }
            }
        }
    }
    
}

#Preview {
    SongListTestView()
}
