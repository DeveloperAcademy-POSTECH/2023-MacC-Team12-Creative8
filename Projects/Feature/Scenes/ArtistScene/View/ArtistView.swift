//
//  ArtistView.swift
//  Feature
//
//  Created by 고혜지 on 10/21/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

private let screenWidth = UIScreen.main.bounds.width
private let screenHeight = UIScreen.main.bounds.height

struct ArtistView: View {
  @Binding var selectedTab: Tab
  let artistName: String
  let artistAlias: String?
  let artistMbid: String

  @StateObject var vm = ArtistViewModel()
  
  var body: some View {
    VStack {
      if vm.isLoading1 || vm.isLoading2 {
        ProgressView()
      } else {
        ScrollView {
          ArtistImageView(vm: vm)
          BookmarkedView(vm: vm, selectedTab: $selectedTab)
          ListView(vm: vm)
        }
      }
    }
    .background(Color.backgroundWhite)
    .navigationTitle("")
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text(vm.artistInfo.name)
          .font(.title3)
          .fontWeight(.semibold)
      }
    }
    .onAppear {
      vm.getArtistInfoFromGenius(artistName: artistName, artistAlias: artistAlias, artistMbid: artistMbid)
      vm.getSetlistsFromSetlistFM(artistMbid: artistMbid)
    }
  }
}

private struct ArtistImageView: View {
  @ObservedObject var vm: ArtistViewModel
  @Query var concertInfo: [ArchivedConcertInfo]
  @Query var likeArtist: [LikeArtist]
  @Environment(\.modelContext) var modelContext
  
  var body: some View {
    ZStack(alignment: .bottom) {
      if vm.image != nil {
        if vm.artistInfo.imageUrl == nil {
          Image(uiImage: vm.image!)
            .renderingMode(.template)
            .foregroundStyle(Color.lineGrey1)
            .background {
              Color.mainGrey1
                .cornerRadius(14)
            }
        } else {
          Image(uiImage: vm.image!)
            .centerCropped()
            .aspectRatio(1.5, contentMode: .fit)
            .cornerRadius(14)
            .overlay(Color.black.opacity(0.2).cornerRadius(14))
        }
      } else {
        ProgressView()
      }
      HStack {
        textLayer
        Spacer()
        buttonLayer
      }
      .padding()
    }
    .padding()
    .onAppear {
      vm.loadImage()
      vm.dataManager.modelContext = modelContext
      vm.isLikedArtist = vm.dataManager.isAddedLikeArtist(likeArtist, vm.artistInfo.mbid)
    }
  }
  
  private var textLayer: some View {
    Text(vm.artistInfo.name)
      .font(.largeTitle)
      .fontWeight(.semibold)
      .foregroundStyle(Color.mainWhite)
  }
  
  private var buttonLayer: some View {
    Button {
      if vm.isLikedArtist {
        vm.dataManager.findArtistAndDelete(likeArtist, vm.artistInfo.mbid)
      } else {
        vm.dataManager.addLikeArtist(
          name: vm.artistInfo.name,
          country: "",
          alias: vm.artistInfo.alias ?? "",
          mbid: vm.artistInfo.mbid,
          gid: vm.artistInfo.gid ?? 0,
          imageUrl: vm.artistInfo.imageUrl ?? "",
          songList: vm.artistInfo.songList ?? []
        )
      }
      vm.isLikedArtist.toggle()
    } label: {
      Circle()
        .frame(width: screenWidth * 0.1)
        .foregroundStyle(Color.mainWhite1)
        .overlay(
          Image(systemName: vm.isLikedArtist ? "heart.fill" : "heart")
            .foregroundStyle(vm.isLikedArtist ? Color.mainOrange : Color.mainWhite)
        )
    }
  }
  
}

private struct BookmarkedView: View {
  @ObservedObject var vm: ArtistViewModel
  @Query var concertInfo: [ArchivedConcertInfo]
  @State var bookmarkedConcerts: [ArchivedConcertInfo] = []
  @Environment(\.dismiss) var dismiss
  @Binding var selectedTab: Tab
  
  var body: some View {
    VStack {
      titleLayer
        .padding()
      
      if vm.showBookmarkedSetlists {
        VStack {
          if bookmarkedConcerts.isEmpty {
            emptyLayer
              .padding(.vertical, 20)
          } else {
            setlistsLayer
            navigationLayer
          }
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(
          Color.mainGrey1
            .cornerRadius(15)
        )
        .padding(.horizontal)
        
      }
    }
    .onAppear {
      bookmarkedConcerts = []
      for concert in concertInfo {
        if concert.artistInfo.name == vm.artistInfo.name {
          bookmarkedConcerts.append(concert)
        }
      }
    }
  }
  
  private var titleLayer: some View {
    HStack {
      Text("북마크한 공연")
        .font(.headline)
        .fontWeight(.bold)
      Spacer()
      Button {
        vm.showBookmarkedSetlists.toggle()
      } label: {
        Image(systemName: vm.showBookmarkedSetlists ? "chevron.down" : "chevron.right")
      }
      .foregroundStyle(Color.mainBlack)
    }
    .padding(.horizontal, 10)
  }
  
  private var emptyLayer: some View {
    VStack(alignment: .center) {
      Text("북마크한 공연이 없습니다.")
        .font(.headline)
        .padding(.bottom)
        .foregroundStyle(Color.mainBlack)
      Group {
        Text("관심있는 공연에 북마크를 눌러 표시해주세요")
        Text("보관함에서도 볼 수 있습니다")
      }
      .font(.footnote)
      .foregroundStyle(Color.fontGrey2)
    }
  }
  
  private var setlistsLayer: some View {
    ForEach(bookmarkedConcerts, id: \.self) { concert in
      HStack {
        Spacer()
        
        // MARK: Date
        VStack {
          Text(vm.getFormattedDateFromDate(date: concert.setlist.date, format: "yyyy"))
            .foregroundStyle(Color.fontGrey25)
            .tracking(1)
          Text(vm.getFormattedDateFromDate(date: concert.setlist.date, format: "MM.dd"))
            .foregroundStyle(Color.mainBlack)
        }
        .font(.headline)
        
        Spacer()
        
        // MARK: Venue
        VStack(alignment: .leading) {
          Text("\(concert.setlist.city), \(concert.setlist.country)")
            .font(.subheadline)
            .foregroundStyle(Color.mainBlack)
          Text(concert.setlist.venue)
            .font(.footnote)
            .foregroundStyle(Color.fontGrey25)
        }
        .lineLimit(1)
        .frame(width: screenWidth * 0.5, alignment: .leading)
        .padding(.vertical, 10)
        
        Spacer()
        
        // MARK: Menu Button
        Menu {
          NavigationLink {
            SetlistView(setlistId: concert.setlist.setlistId, artistInfo: vm.artistInfo)
          } label: {
            Text("세트리스트 보기")
          }

          Button {
            vm.dataManager.deleteArchivedConcertInfo(concert)
            for (index, item) in bookmarkedConcerts.enumerated() {
              if item.id == concert.id {
                bookmarkedConcerts.remove(at: index)
              }
            }
          } label: {
            Text("공연 북마크 취소")
          }

        } label: {
          Image(systemName: "ellipsis")
            .foregroundStyle(Color.mainBlack)
            .font(.title3)
        }
        
        Spacer()
      }
      
      Divider()
        .padding(.horizontal)
        .foregroundColor(Color.lineGrey1)
    }
  }
  
  private var navigationLayer: some View {
    Button {
      vm.archivingviewModel.selectSegment = .bookmark
      vm.archivingviewModel.selectArtist = vm.artistInfo.name
      if selectedTab == .archiving {
        dismiss()
      } else {
        selectedTab = .archiving
      }

    } label: {
      HStack {
        Spacer()
        Text("\(vm.artistInfo.name) 보관함에서 보기")
        Image(systemName: "arrow.right")
      }
      .foregroundColor(Color.mainBlack)
      .font(.footnote)
      .padding()
      .padding(.horizontal, 10)
    }
  }
  
}

private struct ListView: View {
  @ObservedObject var vm: ArtistViewModel
  
  var body: some View {
    VStack {
      titleLayer
        .padding()
      setlistsLayer
      if vm.page != vm.totalPage {
        buttonLayer
      }
    }
  }
  
  private var titleLayer: some View {
    HStack {
      Text("전체 공연 보기")
        .font(.headline)
        .fontWeight(.bold)
        .foregroundStyle(Color.mainBlack)
      Spacer()
    }
    .padding(.horizontal, 10)
  }
  
  private var setlistsLayer: some View {
    ForEach(vm.setlists ?? [], id: \.id) { setlist in
      NavigationLink {
        SetlistView(setlist: setlist, artistInfo: vm.artistInfo)
      } label: {
        HStack {
          Spacer()
          
          // MARK: Date
          VStack {
            Text(vm.getFormattedDateFromString(date: setlist.eventDate ?? "", format: "yyyy") ?? "")
              .foregroundStyle(Color.fontGrey25)
              .tracking(0.5)
            Text(vm.getFormattedDateFromString(date: setlist.eventDate ?? "", format: "MM.dd") ?? "")
              .foregroundStyle(Color.mainBlack)
          }
          .font(.headline)
          
          Spacer()
          
          // MARK: Venue
          VStack(alignment: .leading) {
            let venue = "\(setlist.venue?.city?.name ?? ""), \(setlist.venue?.city?.country?.name ?? "")"
            Text(venue)
              .font(.subheadline)
              .fontWeight(.semibold)
              .foregroundStyle(Color.mainBlack)
            Group {
              if vm.isEmptySetlist(setlist) {
                Text("세트리스트 정보가 아직 없습니다")
              } else {
                let songTitle: String = setlist.sets?.setsSet?.first?.song?.first?.name ?? ""
                Text("01 \(vm.koreanConverter.findKoreanTitle(title: songTitle, songList: vm.artistInfo.songList ?? []) ?? songTitle)")
              }
            }
            .font(.footnote)
            .foregroundStyle(Color.fontGrey25)
          }
          .lineLimit(1)
          .frame(width: screenWidth * 0.5, alignment: .leading)
          .padding(.vertical, 10)
          
          Spacer()
          
          // MARK: Arrow
          Image(systemName: "arrow.right")
            .font(.title3)
            .foregroundStyle(Color.mainBlack)
          
          Spacer()
        }
      }
      
      Divider()
        .padding(.horizontal)
        .foregroundColor(Color.lineGrey1)
    }
  }
  
  private var buttonLayer: some View {
    VStack {
      Button {
        vm.fetchNextPage(artistMbid: vm.artistInfo.mbid)
      } label: {
        if vm.isLoading3 {
          ProgressView()
            .padding()
        } else {
          Text("더보기")
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundStyle(Color.mainBlack)
            .padding()
        }
      }
      
      Divider()
        .foregroundStyle(Color.lineGrey1)
        .padding(.horizontal)
    }
  }
  
}

#Preview {
//  ArtistView(selectedTab: .constant(.archiving), artistName: "IU", artistAlias: "아이유", artistMbid: "b9545342-1e6d-4dae-84ac-013374ad8d7c")
  ArtistView(selectedTab: .constant(.archiving), artistName: "검정치마", artistAlias: "검정치마", artistMbid: "b9545342-1e6d-4dae-84ac-013374ad8d7c")
}
