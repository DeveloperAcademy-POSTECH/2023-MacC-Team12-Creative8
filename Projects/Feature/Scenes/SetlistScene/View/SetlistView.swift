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
  @State var setlist: Setlist?
  var setlistId: String?
  var artistInfo: ArtistInfo?
  
  @StateObject var vm = SetlistViewModel()
  @Query var concertInfo: [ArchivedConcertInfo]
  @Environment(\.modelContext) var modelContext
  @State private var showToastMessage = false
  
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
                vm.dataManager.findConcertAndDelete(concertInfo, setlist?.id ?? "")
              } else {
                let newArtist = SaveArtistInfo(
                  name: setlist?.artist?.name ?? "",
                  country: setlist?.venue?.city?.country?.name ?? "",
                  alias: artistInfo?.alias ?? "",
                  mbid: artistInfo?.mbid ?? "",
                  gid: artistInfo?.gid ?? 0,
                  imageUrl: artistInfo?.imageUrl ?? "",
                  songList: artistInfo?.songList ?? [])
                let newSetlist = SaveSetlist(
                  setlistId: setlist?.id ?? "",
                  date: vm.convertDateStringToDate(setlist?.eventDate ?? "") ?? Date(),
                  venue: setlist?.venue?.name ?? "",
                  title: setlist?.tour?.name ?? "")
                vm.dataManager.addArchivedConcertInfo(newArtist, newSetlist)
                showToastMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                  showToastMessage = false
                }
              }
              vm.isBookmarked.toggle()
            }, label: {
              Image(systemName: vm.isBookmarked ? "bookmark.fill" : "bookmark")
            })
          }
        }
      }
      if let setlist = setlist {
        if !vm.isEmptySetlist(setlist) {
          ExportPlaylistButtonView(setlist: setlist, artistInfo: artistInfo, vm: vm)
            .padding(.horizontal, 30)
        }
      }
      if showToastMessage {
        VStack {
          ToastMessageView(message: "북마크한 공연이 추가되었습니다.")
            .padding(.horizontal, 30)
          Spacer()
        }
      }
    }
    .onAppear {
      if setlistId != nil {
        vm.dataService.fetchOneSetlistFromSetlistFM(setlistId: setlistId!) { result in
          if let result = result {
            vm.isLoading = true
            DispatchQueue.main.async {
              self.setlist = result
              vm.isLoading = false
            }
          }
        }
      }
      vm.dataManager.modelContext = modelContext
      vm.isBookmarked = vm.dataManager.isAddedConcert(concertInfo, setlist?.id ?? "")
    }
  }
  
  var concertInfoArea: some View {
    ZStack {
      Rectangle()
        .cornerRadius(14, corners: [.bottomLeft, .bottomRight])
        .foregroundStyle(Color.backgroundWhite)
        .ignoresSafeArea()
      ConcertInfoView(
        artist: artistInfo?.name ?? "-",
        date: vm.getFormattedDateFromString(date: setlist?.eventDate ?? "", format: "yyyy년 MM월 dd일") ?? "-",
        venue: setlist?.venue?.name ?? "-",
        tour: setlist?.tour?.name ?? "-"
      )
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
      if let setlist = setlist {
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
  
}

// MARK: ConcertInfoView
private struct ConcertInfoView: View {
  var artist: String
  var date: String
  var venue: String
  var tour: String
  
  var body: some View {
    VStack {
      Group {
        Text("\(artist) ")
        +
        Text("Setlist")
          .foregroundStyle(Color.fontGrey2)
      }
      .font(.largeTitle)
      .fontWeight(.semibold)
      .frame(maxWidth: .infinity, alignment: .leading)
      
      InfoComponent(text1: "날짜", text2: date)
      InfoComponent(text1: "장소", text2: venue)
      InfoComponent(text1: "공연", text2: tour)
      
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
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @ObservedObject var vm: SetlistViewModel
  @State private var showToastMessage = false
  
  var body: some View {
    VStack {
      Spacer()
      if showToastMessage {
        ToastMessageView(message: "1~2분 후 Apple Music에서 확인하세요")
      }
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
    .sheet(isPresented: $vm.showModal) {
      BottomModalView(setlist: setlist, artistInfo: artistInfo, vm: vm, showToastMessage: $showToastMessage)
        .presentationDetents([.fraction(0.3)])
        .presentationDragIndicator(.visible)
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
  @Binding var showToastMessage: Bool
  
  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      
      listView(title: "Apple Music에 옮기기", description: nil, action: {
        AppleMusicService().requestMusicAuthorization()
        CheckAppleMusicSubscription.shared.appleMusicSubscription()
        AppleMusicService().addPlayList(name: "\(artistInfo?.name ?? "" ) @ \(setlist?.eventDate ?? "")", musicList: vm.setlistSongName, singer: artistInfo?.name ?? "", venue: setlist?.venue?.name)
        vm.showModal.toggle()
        showToastMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          showToastMessage = false
        }
      })
      
      Spacer()
      
      listView(
        title: "세트리스트 캡처하기",
        description: "Bugs, FLO, genie, VIBE의 유저이신가요? OCR 서비스를\n사용해 캡쳐만으로 플레이리스트를 만들어 보세요.",
        action: {
          takeSetlistToImage(vm.setlistSongKoreanName, artistInfo?.name ?? "")
          vm.showModal.toggle()
        }
      )
      
      Spacer()
    }
    .padding(.horizontal, 30)
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

private struct ToastMessageView: View {
  let message: String
  
  var body: some View {
     Text(message)
      .foregroundStyle(Color.fontWhite)
      .font(.subheadline)
      .padding(.vertical)
      .frame(maxWidth: .infinity)
      .background(
        Color.fontGrey2
          .cornerRadius(27)
      )
  }
}

// MARK: Preview
//#Preview {
//  //  NavigationStack {
//  //    SetlistView()
//  //  }
//  //  EmptySetlistView()
//  //  ConcertInfoView()
//  //  AddPlaylistButtonView()
//  //  ListRowView(index: 1, title: "후라이의 꿈", info: "info...")
////  BottomView()
//  ToastMessageView(message: "1~2분 후 Apple Music에서 확인하세요")
//    .padding(30)
//}
