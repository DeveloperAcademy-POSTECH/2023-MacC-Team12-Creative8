//
//  SetlistView.swift
//  Feature
//
//  Created by 고혜지 on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

private let gray: Color = Color(hex: 0xEAEAEA)
private let screenWidth = UIScreen.main.bounds.width
private let screenHeight = UIScreen.main.bounds.height

struct SetlistView: View {
    @State private var isBookmarked: Bool = false
    @State private var isEmptySetlist: Bool = false
    
    var body: some View {
        VStack {
            Group {
                NavigationBarView()
                
                ConcertInfoView(
                    date: "2023년 10월 28일",
                    venue: "Olympic Hall, Seoul",
                    artist: "잔나비",
                    name: "판타스틱 올드 패션드 송년회",
                    isBookmarked: $isBookmarked
                )

                ConcertInfoDetailView(
                    entrance: "17:00",
                    begin: "17:00",
                    venue: "Olympic Hall"
                )
            }
            .padding(.bottom)

            if isEmptySetlist {
                EmptySetlistView()
            } else {
                ZStack {
                    ScrollView {
                        ListView()
                        BottomView()
                    }
                    .ignoresSafeArea()

                    AddPlaylistButton()
                }
            }
        }
    }
}

private struct NavigationBarView: View {
    var body: some View {
        HStack {
            Button(action: {
                
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24))
            })
            
            Spacer()
            
            Text("세트리스트")
                .font(.system(size: 19))
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 24))
            })
        }
        .frame(width: screenWidth * 0.9)
        .foregroundStyle(Color.primary)
    }
}

private struct ConcertInfoView: View {
    var date: String
    var venue: String
    var artist: String
    var name: String
    @Binding var isBookmarked: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(gray)
            
            VStack(alignment: .leading) {
                Spacer()
                
                HStack {
                    Text(date)
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                    Spacer()
                    Text(venue)
                        .font(.system(size: 12))
                }
                Spacer()
                
                Text(artist)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)

                HStack {
                    Text(name)
                        .font(.system(size: 14))
                    Spacer()
                    Button {
                        isBookmarked.toggle()
                    } label: {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundStyle(Color.primary)
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
            
        }
        .frame(width: screenWidth * 0.9, height: screenHeight * 0.1)
    }
}

private struct ConcertInfoDetailView: View {
    var entrance: String
    var begin: String
    var venue: String
    @State var showConcertDetail: Bool = true
    
    var body: some View {
        VStack(spacing: 15) {
            
            concertDetailToggleButton
            
            if showConcertDetail {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(gray)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("입장")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                            Spacer()
                            Text(entrance)
                                .font(.system(size: 19))
                        }
                        
                        Rectangle()
                            .frame(width: 1)
                            .padding(.horizontal)

                        VStack(alignment: .leading) {
                            Text("공연시작")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                            Spacer()
                            Text(begin)
                                .font(.system(size: 19))
                        }
                        
                        Rectangle()
                            .frame(width: 1)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("장소")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                            Spacer()
                            Text(venue)
                                .font(.system(size: 19))
                        }
                    }
                    .padding(10)
                }
                .frame(width: screenWidth * 0.9, height: screenHeight * 0.075)
            }
        }
    }
    
    var concertDetailToggleButton: some View {
        Button(action: {
            showConcertDetail.toggle()
        }, label: {
            Image(systemName: showConcertDetail ? "chevron.down" : "chevron.up")
                .foregroundColor(.primary)
        })
    }
}

private struct ListView: View {
    let setlist: Setlist = dummySetlist
    let koreanTitleConverter: KoreanTitleConverter = KoreanTitleConverter.shared
    
    var body: some View {
        LazyVStack {
            ForEach(setlist.sets?.setsSet ?? [], id: \.name) { session in
                VStack(alignment: .leading, spacing: 20) {
                    if let sessionName = session.name {
                        Text(sessionName)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .opacity(0.3)
                    }
                    
                    let songs = session.song ?? []
                    ForEach(Array(songs.enumerated()), id: \.offset) { index, song in
                        if let title = song.name {
                            if song.tape != nil && song.tape == true {
                                ListRowView(
                                    index: nil,
                                    title: koreanTitleConverter.convertTitleToKorean(title: title, songList: iuSongList) ?? title,
                                    info: song.info
                                )
                                .opacity(0.6)
                            } else {
                                ListRowView(
                                    index: index,
                                    title: koreanTitleConverter.convertTitleToKorean(title: title, songList: iuSongList) ?? title,
                                    info: song.info
                                )
                            }
                            
                            if index + 1 < songs.count {
                                Divider()
                            }
                        }
                    }
                    
                }
                .padding(.vertical, screenHeight * 0.03)
            }
        }
        .padding(.horizontal, screenWidth * 0.1)
        .padding(.bottom)
        
    }
}

private struct ListRowView: View {
    var index: Int?
    var title: String
    var info: String?
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    if let index = index {
                        Text(String(format: "%02d", index))
                    } else {
                        Image(systemName: "recordingtape")
                    }
                }
                .frame(width: 50)
                
                Text(title)
                    .frame(width: screenWidth * 0.65, height: 16, alignment: .leading)
            }
            .fontWeight(.semibold)
            
            if let info = info {
                Text(info)
                    .fontWeight(.regular)
                    .opacity(0.6)
                    .frame(width: screenWidth * 0.65, alignment: .leading)
                    .padding(.leading, 55)
            }
        }
        .font(.system(size: 16))
    }
}

private struct BottomView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: screenHeight * 0.25)
                .foregroundColor(gray)
            
            VStack(alignment: .leading, spacing: 30) {
                Text("세트리스트 정보 수정을 원하시나요?")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("잘못된 세트리스트 정보를 발견하셨다면,")
                    Text("Setlist.fm").underline() + Text("에서 수정할 수 있습니다.")
                }
                .opacity(0.6)
                .font(.system(size: 13))
                
                Button(action: {}, label: {
                    HStack {
                        Spacer()
                        Text("바로가기")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
                })
            }
            .padding(.horizontal)
        }
        .frame(height: screenHeight * 0.25)
    }
}

private struct AddPlaylistButton: View {
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                
            }, label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: screenWidth * 0.85, height: screenHeight * 0.065)
                    .foregroundStyle(gray)
                    .overlay {
                        Text("플레이리스트 등록")
                            .foregroundStyle(Color.primary)
                            .bold()
                    }
            })
            .padding(.bottom)
        }
    }
}

private struct EmptySetlistView: View {
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            
            Text("세트리스트가 없습니다.")
                .font(.system(size: 16))
                .fontWeight(.semibold)

                Text("세트리스트를 직접 작성하고 싶으신가요?\nSetlist.fm 바로가기에서 추가하세요.")
                .opacity(0.6)
                .font(.system(size: 13))
            
            Button(action: {
                
            }, label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: screenWidth * 0.85, height: screenHeight * 0.065)
                    .foregroundStyle(gray)
                    .overlay {
                        Text("Setlist.fm 바로가기")
                            .foregroundStyle(Color.primary)
                            .bold()
                    }
            })
            .padding(.top, screenHeight * 0.05)
    
            Spacer()
        }
    }
}

#Preview {
    SetlistView()
}
