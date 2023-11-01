//
//  SetlistView.swift
//  Feature
//
//  Created by 고혜지 on 11/1/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import SwiftData
import Core

private let gray: Color = Color(hex: 0xEAEAEA)

struct SetlistView: View {
  let setlist: Setlist
  let artistInfo: ArtistInfo?
  @StateObject var vm = SetlistViewModel()
  @Query var concertInfo: [ArchivedConcertInfo]
  
  var body: some View {
    ZStack {
      ScrollView {
        VStack(spacing: -1) {
          concertInfoArea
          dotLine
          setlistArea
        }
        .background(Color.black)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
              if vm.isBookmarked {
                
              } else {
                
              }
              vm.isBookmarked.toggle()
            }, label: {
              Image(systemName: vm.isBookmarked ? "bookmark.fill" : "bookmark")
            })
          }
        }
        .onAppear {
//          vm.isBookmarked = vm.dataManager.
        }
        .sheet(isPresented: $vm.showModal) {
          BottomModalView(setlist: setlist, artistInfo: artistInfo, vm: vm)
            .presentationDetents([.fraction(0.4)])
            .presentationDragIndicator(.visible)
        }
      }
      if !vm.isEmptySetlist(setlist) {
        ExportPlaylistButtonView(vm: vm)
          .padding(.horizontal, 30)
      }
    }
  }
  
  var concertInfoArea: some View {
    ZStack {
      Rectangle()
        .cornerRadius(14, corners: [.bottomLeft, .bottomRight])
        .foregroundStyle(Color.backgroundWhite)
        .ignoresSafeArea()
      ConcertInfoView()
        .padding(30)
        .padding(.bottom)
    }
  }
  
  var dotLine: some View {
    Rectangle()
      .stroke(style: StrokeStyle(dash: [5]))
      .frame(height: 1)
      .padding(.horizontal)
      .foregroundStyle(Color.gray)
  }
  
  var setlistArea: some View {
    ZStack {
      Rectangle()
        .cornerRadius(14, corners: [.topLeft, .topRight])
        .foregroundStyle(Color.backgroundWhite)
        .ignoresSafeArea()
      if vm.isEmptySetlist(setlist) {
        EmptySetlistView()
          .padding(30)
      } else {
        VStack {
          ListView(setlist: setlist, artistInfo: artistInfo, vm: vm)
            .padding(30)
          Divider() // TODO: divider 때문에 padding(30)을 다 따로 줘야하는데 방법이 없나?
            .padding(.horizontal)
          BottomView()
            .padding(30)
        }
      }
    }
  }
  
}

// MARK: ConcertInfoView
private struct ConcertInfoView: View {
  var body: some View {
    VStack {
      Group {
        //        Text("Noel Gallagher’s High Flying Birds ")
        Text("Post Malone ")
        +
        Text("Setlist")
          .foregroundStyle(Color.fontGrey2)
      }
      .font(.largeTitle)
      .fontWeight(.semibold)
      .frame(maxWidth: .infinity, alignment: .leading)
      
      InfoComponent(text1: "날짜", text2: "2023년 10월 13일")
      InfoComponent(text1: "장소", text2: "Olympic Hall, Seoul, South Korea")
      InfoComponent(text1: "공연", text2: "If Yall Weren’t Here, I’de be cryin")
      
    }
  }
}

private struct InfoComponent: View {
  let text1: String
  let text2: String
  
  var body: some View {
    HStack {
      Text(text1)
        .padding()
        .background(Color.mainGrey1.cornerRadius(12))
      Spacer()
      Text(text2)
        .font(.body)
        .frame(width: UIWidth * 0.5, alignment: .leading)
      Spacer()
    }
    .frame(maxWidth: .infinity)
  }
}

// MARK: EmptySetlistView
private struct EmptySetlistView: View {
  var body: some View {
    VStack {
      Text("세트리스트가 없습니다.")
        .font(.callout)
        .fontWeight(.semibold)
        .padding(.bottom)
        .padding(.top, 100)
      
      Text("세트리스트를 직접 작성하고 싶으신가요?\nSetlist.fm 바로가기에서 추가하세요.")
        .foregroundStyle(Color.fontGrey2)
        .font(.footnote)
        .multilineTextAlignment(.center)
      
      SetlistFMLinkButtonView()
        .padding(.top, 100)
    }
  }
}

// MARK: ExportPlaylistButtonView
struct ExportPlaylistButtonView: View {
  @ObservedObject var vm: SetlistViewModel
  
  var body: some View {
    VStack {
      Spacer()
      Button(action: {
        vm.showModal.toggle()
      }, label: {
        Text("플레이리스트 내보내기")
          .foregroundStyle(Color.blockFontWhite)
          .font(.callout)
          .fontWeight(.semibold)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 20)
          .background(Color.blockFontBlack)
          .cornerRadius(14)
      })
    }
  }
}

// MARK: SetlistFMLinkButtonView
struct SetlistFMLinkButtonView: View {
  var body: some View {
    VStack {
      if let url = URL(string: "https://www.setlist.fm") {
        Link(destination: url) {
          Text("Setlist.fm 바로가기")
            .foregroundStyle(Color.primary) // TODO: Accent Color 변경되면 빼도 될 듯?
            .font(.callout)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.mainGrey1)
            .cornerRadius(14)
        }
      }
    }
  }
}

// MARK: ListView
private struct ListView: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @ObservedObject var vm: SetlistViewModel
  
  var body: some View {
    VStack {
      ForEach(setlist?.sets?.setsSet ?? [], id: \.name) { session in
        VStack(alignment: .leading) {
          if let sessionName = session.name {
            Text(sessionName)
              .font(.headline)
              .fontWeight(.bold)
              .foregroundStyle(Color.fontGrey25)
              .padding(.horizontal)
              .padding(.top, 30)
          }
          
          let songs = session.song ?? []
          ForEach(Array(songs.enumerated()), id: \.offset) { index, song in
            if let title = song.name {
              
              Group {
                if song.tape != nil && song.tape == true {
                  ListRowView(
                    index: nil,
                    title: vm.koreanConverter.findKoreanTitle(title: title, songList: artistInfo?.songList ?? []) ?? title,
                    info: song.info
                  )
                  .opacity(0.6)
                } else {
                  ListRowView(
                    index: index + 1,
                    title: vm.koreanConverter.findKoreanTitle(title: title, songList: artistInfo?.songList ?? []) ?? title,
                    info: song.info
                  )
                }
              }
              .padding(.horizontal)
              .padding(.vertical, 10)
              
              if index + 1 < songs.count {
                Divider()
              }
              
              // 애플 뮤직용 음악 배열
              if !vm.setlistSongName.contains(title) {
                let _ = vm.setlistSongName.append(title)
              }
              
              // 스크린샷용 음악 배열
              let tmp = vm.koreanConverter.findKoreanTitle(title: title, songList: artistInfo?.songList ?? []) ?? title
              if !vm.setlistSongKoreanName.contains(tmp) {
                let _ = vm.setlistSongKoreanName.append(tmp)
              }
              
            }
          }
        }
      }
    }
  }
}

private struct ListRowView: View {
  var index: Int?
  var title: String
  var info: String?
  
  var body: some View {
    HStack(alignment: .top, spacing: 20) {
      if let index = index {
        Text(String(format: "%02d", index))
      } else {
        Image(systemName: "recordingtape")
      }
      
      VStack(alignment: .leading, spacing: 10) {
        Text(title)
          .lineLimit(1)
        
        if let info = info {
          Text(info)
            .fontWeight(.regular)
            .foregroundStyle(Color.fontGrey25)
        }
      }
    }
    .font(.callout)
    .fontWeight(.semibold)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private struct BottomView: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("세트리스트 정보 수정을 원하시나요?")
        .font(.headline)
        .padding(.bottom, 30)
      
      VStack(alignment: .leading) {
        Text("잘못된 세트리스트 정보를 발견하셨다면,")
        Text("Setlist.fm").underline() + Text("에서 수정할 수 있습니다.")
      }
      .font(.footnote)
      .foregroundStyle(Color.fontGrey2)
      .padding(.bottom, 50)
      
      SetlistFMLinkButtonView()
        .padding(.bottom, 50)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private struct BottomModalView: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @ObservedObject var vm: SetlistViewModel
  
  var body: some View {
    Spacer().frame(height: UIHeight * 0.07)
    VStack(alignment: .leading, spacing: UIHeight * 0.03) {
      Group {
        listView(title: "Apple Music에 옮기기", description: nil, action: {
          AppleMusicService().requestMusicAuthorization()
          CheckAppleMusicSubscription.shared.appleMusicSubscription()
          AppleMusicService().addPlayList(name: "\(artistInfo?.name ?? "") @ \(setlist?.eventDate ?? "")", musicList: vm.setlistSongName, singer: artistInfo?.name, venue: setlist?.venue?.name)
          
        })
        
        listView(
          title: "세트리스트 캡처하기",
          description: "Bugs, FLO, genie, VIBE의 유저이신가요? OCR 서비스를\n사용해 캡쳐만으로 플레이리스트를 만들어 보세요.",
          action: {
            takeSetlistToImage(vm.setlistSongKoreanName, artistInfo?.name ?? "")
            
          }
        )
      }
      .opacity(0.6)
      Spacer()
    }
    .padding(.horizontal, 20)
  }
  
  private func listView(title: String, description: String?, action: @escaping () -> Void) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: UIHeight * 0.01) {
        Text(title)
          .font(.system(size: 16, weight: .semibold))
        if let description = description {
          Text(description)
            .font(.system(size: 12, weight: .regular))
            .opacity(0.8)
        }
      }
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundStyle(.gray)
        .onTapGesture {
          action()
        }
    }
  }
}

extension View {
  func convertDateStringToDate(_ dateString: String, format: String = "dd-MM-yyyy") -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Optional: Specify the locale
    
    if let date = dateFormatter.date(from: dateString) {
      return date
    } else {
      return nil // 날짜 형식이 맞지 않을 경우 nil 반환
    }
  }
}

// MARK: Preview
#Preview {
  //  NavigationStack {
  //    SetlistView()
  //  }
  //  EmptySetlistView()
  //  ConcertInfoView()
  //  AddPlaylistButtonView()
  //  ListRowView(index: 1, title: "후라이의 꿈", info: "info...")
  BottomView()
}
