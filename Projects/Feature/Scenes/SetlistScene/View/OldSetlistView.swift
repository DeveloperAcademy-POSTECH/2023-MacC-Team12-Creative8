//
//  SetlistView.swift
//  Feature
//
//  Created by 고혜지 on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData
import UI
import Core

private let gray: Color = Color(hex: 0xEAEAEA)
private let screenWidth = UIScreen.main.bounds.width
private let screenHeight = UIScreen.main.bounds.height

struct OldSetlistView: View {
  let setlist: Setlist
  let artistInfo: ArtistInfo?
  @StateObject var vm = SetlistViewModel()
  @State private var isShowModal = false
  
  var body: some View {
    VStack {
      if vm.isEmptySetlist {
        OldConcertInfoView(setlist: setlist, artistInfo: artistInfo, vm: vm)
        OldEmptySetlistView()
      } else {
        ZStack {
          ScrollView {
            OldConcertInfoView(setlist: setlist, artistInfo: artistInfo, vm: vm)
            ListView(setlist: setlist, artistInfo: artistInfo, vm: vm)
            BottomView()
          }
          addPlaylistButton
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
        VStack {
          Text(artistInfo?.name ?? "")
            .font(.system(size: 12))
          Text("세트리스트")
            .font(.system(size: 16))
        }
        .fontWeight(.semibold)
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: {
          vm.isBookmarked.toggle()
        }, label: {
          Image(systemName: vm.isBookmarked ? "bookmark.fill" : "bookmark")
        })
      }
    }
    .foregroundStyle(Color.primary)
    .onAppear {
      if setlist.sets?.setsSet?.isEmpty == true {
        vm.isEmptySetlist = true
      }
    }
    .sheet(isPresented: self.$isShowModal) {
      BottomModalView(setlist: setlist, artistInfo: artistInfo, vm: vm)
        .presentationDetents([.fraction(0.4)])
        .presentationDragIndicator(.visible)
    }
  }
  
  private var addPlaylistButton: some View {
    VStack {
      Spacer()
      Button(action: {
        self.isShowModal.toggle()
      }, label: {
        RoundedRectangle(cornerRadius: 10)
          .frame(width: UIWidth * 0.85, height: UIHeight * 0.065)
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

private struct OldConcertInfoView: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @ObservedObject var vm: SetlistViewModel
  @Query var concertInfo: [ArchivedConcertInfo]
  @StateObject var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 14)
        .foregroundStyle(Color.black)
      
      VStack(alignment: .leading, spacing: 10) {
        Group {
          Text(artistInfo?.name ?? "")
            .font(.system(size: 26))
            .fontWeight(.semibold)
          
          Text(setlist?.tour?.name ?? "")
            .opacity(0.6)
        }
        .padding(.horizontal)
        
        Divider()
          .background(Color.white)
          .padding(.vertical, 5)
        
        Group {
          let venue = "\(setlist?.venue?.name ?? ""), \(setlist?.venue?.city?.name ?? ""), \(setlist?.venue?.city?.country?.name ?? "")"
          OldInfoComponenet(title: venue, subTitle: "Place")
          HStack {
            OldInfoComponenet(title: setlist?.eventDate ?? "", subTitle: "Date")
            Spacer()
            OldInfoComponenet(title: "-", subTitle: "Time")
            Spacer()
            Spacer()
          }
        }
        .padding(.horizontal)
        
        Button(action: {
          if vm.isBookmarked {
            for i in 0..<concertInfo.count {
              if concertInfo[i].setlist.setlistId == setlist?.id {
                dataManager.deleteArchivedConcertInfo(concertInfo[i])
              }
            }
          } else {
            let newArtist = SaveArtistInfo(
              name: setlist?.artist?.name ?? "",
              country: "",
              alias: artistInfo?.alias ?? "",
              mbid: artistInfo?.mbid ?? "",
              gid: artistInfo?.gid ?? 0,
              imageUrl: artistInfo?.imageUrl ?? "",
              songList: dataManager.songListEncoder(artistInfo?.songList ?? []))
            let newSetlist = SaveSetlist(
              setlistId: setlist?.id ?? "",
              date: convertDateStringToDate(setlist?.eventDate ?? "") ?? Date(),
              venue: setlist?.venue?.name ?? "",
              title: setlist?.tour?.name ?? "")
            dataManager.addArchivedConcertInfo(newArtist, newSetlist)
          }
        }, label: {
          ZStack {
            RoundedRectangle(cornerRadius: 14)
              .foregroundColor(vm.isBookmarked ? Color.white : Color.gray)
            HStack {
              Text("해당 공연 다시 듣기")
              Spacer()
              Image(systemName: "checkmark")
            }
            .padding(.horizontal)
            .foregroundStyle(vm.isBookmarked ? Color.black : Color.white)
            .fontWeight(.semibold)
          }
          .frame(height: UIHeight * 0.065)
        })
        
      }
      .font(.system(size: 16))
      .padding(.horizontal)
      .foregroundStyle(Color.white)
    }
    .padding(.horizontal)
    .frame(height: UIHeight * 0.35)
    .onAppear {
      dataManager.modelContext = modelContext
      vm.isBookmark(concertInfo, setlist)
    }
    .onChange(of: concertInfo) { _, newValue in
      vm.isBookmark(newValue, setlist)
    }
  }
}

private struct OldInfoComponenet: View {
  let title: String
  let subTitle: String
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
      Text(subTitle)
        .font(.system(size: 10))
        .opacity(0.4)
    }
  }
}

private struct ListView: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  let koreanConverter: KoreanConverter = KoreanConverter.shared
  @ObservedObject var vm: SetlistViewModel
  
  var body: some View {
    VStack {
      ForEach(setlist?.sets?.setsSet ?? [], id: \.name) { session in
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
                  title: koreanConverter.findKoreanTitle(title: title, songList: artistInfo?.songList ?? []) ?? title,
                  info: song.info
                )
                .opacity(0.6)
              } else {
                ListRowView(
                  index: index,
                  title: koreanConverter.findKoreanTitle(title: title, songList: artistInfo?.songList ?? []) ?? title,
                  info: song.info
                )
              }
              if index + 1 < songs.count {
                Divider()
              }
              // 애플 뮤직용 음악 배열
              if !vm.setlistSongName.contains(title) {
                let _ = vm.setlistSongName.append(title)
              }
              
              // 스크린샷용 음악 배열
              let tmp = koreanConverter.findKoreanTitle(title: title, songList: artistInfo?.songList ?? []) ?? title
              if !vm.setlistSongKoreanName.contains(tmp) {
                let _ = vm.setlistSongKoreanName.append(tmp)
              }
              
            }
          }
        }
        .padding(.vertical, UIHeight * 0.03)
      }
    }
    .padding(.horizontal, UIWidth * 0.1)
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
          .frame(width: UIWidth * 0.65, height: 16, alignment: .leading)
      }
      .fontWeight(.semibold)
      
      if let info = info {
        Text(info)
          .fontWeight(.regular)
          .opacity(0.6)
          .frame(width: UIWidth * 0.65, alignment: .leading)
          .padding(.leading, 55)
      }
    }
    .font(.system(size: 16))
  }
}

private struct BottomView: View {
  var body: some View {
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
}

private struct OldEmptySetlistView: View {
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
          .frame(width: UIWidth * 0.85, height: UIHeight * 0.065)
          .foregroundStyle(gray)
          .overlay {
            Text("Setlist.fm 바로가기")
              .foregroundStyle(Color.primary)
              .bold()
          }
      })
      .padding(.top, UIHeight * 0.05)
      
      Spacer()
    }
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
