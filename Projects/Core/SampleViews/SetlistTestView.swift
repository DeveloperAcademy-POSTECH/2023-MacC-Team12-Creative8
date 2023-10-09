//
//  SetlistTestView.swift
//  Core
//
//  Created by 고혜지 on 10/10/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct SetlistTestView: View {
    let dataService: DataService = DataService.shared
    
    @State private var textFieldText: String = ""
    @State private var artistMbid: String = ""
    @State private var page: Int = 0
    @State private var setlists: SetlistListModel?
    @State private var totalPage: Int = 0
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("add artist name here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    isLoading = true
                    artistMbid = textFieldText
                    textFieldText = ""
                    page = 1
                    dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: page) { result in
                        if let result = result {
                            DispatchQueue.main.async {
                                setlists = result
                                totalPage = Int((setlists?.total ?? 1) / (setlists?.itemsPerPage ?? 1) + 1)
                                isLoading = false
                            }
                        } else {
                            print("Failed to fetch setlist data.")
                        }
                    }
                }, label: {
                    Text("Find")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                })
                .padding(.horizontal)
                
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    listView
                }
                
                if page != 0 {
                    PageButtonView
                }
                
            }
        }
        .navigationTitle("Setlist")
    }
}

extension SetlistTestView {
    
    var listView: some View {
        return List {
            ForEach(setlists?.setlist ?? [], id: \.id) { setlist in
                NavigationLink {
                    Text("Artist: \(setlist.artist?.name ?? "")")
                    Text("Location: \(setlist.venue?.name ?? ""), \(setlist.venue?.city?.name ?? ""), \(setlist.venue?.city?.state ?? "")")
                    Text("Date: \(setlist.eventDate ?? "")")
                    ForEach(setlist.sets?.setsSet ?? [], id: \.name) { session in
                        List {
                            Section(header: Text("\(session.name ?? "")")) {
                                ForEach(session.song ?? [], id: \.name) { song in
                                    VStack(alignment: .leading) {
                                        Text("\(song.name ?? "")")
                                        if song.info != nil {
                                            Text("info: \(song.info ?? "")")
                                                .font(.caption)
                                        }
                                        if song.cover != nil {
                                            Text("cover: \(song.cover?.name ?? "")")
                                                .font(.caption)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Text("\(setlist.artist?.name ?? ""), at \(setlist.venue?.name ?? ""), \(setlist.venue?.city?.name ?? ""), \(setlist.venue?.city?.state ?? "")")
                }
            }
        }
    }
    
    var PageButtonView: some View {
        HStack {
            Button {
                isLoading = true
                page = 1
                dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: page) { result in
                    if let result = result {
                        DispatchQueue.main.async {
                            setlists = result
                            isLoading = false
                        }
                    } else {
                        print("Failed to fetch setlist data.")
                    }
                }
            } label: {
                Image(systemName: "chevron.left.2")
                    .padding(.horizontal)
            }
            
            Button {
                if page > 1 {
                    isLoading = true
                    page -= 1
                    dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: page) { result in
                        if let result = result {
                            DispatchQueue.main.async {
                                setlists = result
                                isLoading = false
                            }
                        } else {
                            print("Failed to fetch setlist data.")
                        }
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .padding(.horizontal)
            }
            
            Text("\(page)  /  \(totalPage)")
                .padding(.horizontal)
            
            Button {
                if totalPage > page {
                    isLoading = true
                    page += 1
                    dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: page) { result in
                        if let result = result {
                            DispatchQueue.main.async {
                                setlists = result
                                isLoading = false
                            }
                        } else {
                            print("Failed to fetch setlist data.")
                        }
                    }
                }
            } label: {
                Image(systemName: "chevron.right")
                    .padding(.horizontal)
            }
            
            Button {
                isLoading = true
                page = totalPage
                dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: page) { result in
                    if let result = result {
                        DispatchQueue.main.async {
                            setlists = result
                            isLoading = false
                        }
                    } else {
                        print("Failed to fetch setlist data.")
                    }
                }
                
            } label: {
                Image(systemName: "chevron.right.2")
                    .padding(.horizontal)
            }
            
        }
    }
    
}

#Preview {
    SetlistTestView()
}
