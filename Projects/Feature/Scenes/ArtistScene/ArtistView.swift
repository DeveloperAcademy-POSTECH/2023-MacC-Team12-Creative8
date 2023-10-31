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
          BookmarkedView(vm: vm)
          ListView(vm: vm)
        }
      }
    }
    .navigationTitle("")
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text(vm.artistInfo?.name ?? "")
          .font(.title3)
          .fontWeight(.semibold)
      }
    }
    .foregroundStyle(Color.fontBlack)
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
        imageLayer
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
      vm.isLikedArtist = vm.dataManager.isLikeArtist(likeArtist, vm.artistInfo?.mbid ?? "")
    }
  }
  
  private var imageLayer: some View {
    Image(uiImage: vm.image!)
      .centerCropped()
      .aspectRatio(1.5, contentMode: .fit)
      .cornerRadius(14)
      .overlay(Color.black.opacity(0.2).cornerRadius(14))
  }
  
  private var textLayer: some View {
    Text(vm.artistInfo?.name ?? "")
      .font(.largeTitle)
      .fontWeight(.semibold)
      .foregroundStyle(Color.fontWhite)
  }
  
  private var buttonLayer: some View {
    Button {
      vm.toggleLikeButton()
    } label: {
      Circle()
        .frame(width: screenWidth * 0.1)
        .foregroundStyle(Color.mainWhite1)
        .overlay(
          Image(systemName: vm.isLikedArtist ? "heart.fill" : "heart")
            .foregroundStyle(vm.isLikedArtist ? Color.blockOrange : Color.mainWhite)
        )
    }
  }
  
}

private struct BookmarkedView: View {
  @ObservedObject var vm: ArtistViewModel
  // TODO: 쿼리에 아티스트 이름 필터 들어가야 함
  @Query var concertInfo: [ArchivedConcertInfo]
  
  var body: some View {
    VStack {
      titleLayer
        .padding()
      
      if vm.showBookmarkedSetlists {
        VStack {
          if concertInfo.isEmpty == true {
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
      .foregroundStyle(Color.fontBlack)
    }
  }
  
  private var emptyLayer: some View {
    VStack(alignment: .center) {
      Text("다시 듣기한 공연이 없습니다.")
        .font(.headline)
        .padding(.bottom)
        .foregroundStyle(Color.fontBlack)
      Group {
        Text("다시 듣기할 공연을 눌러 표시해주세요.")
        Text("아카이빙에서도 볼 수 있어요.")
      }
      .font(.footnote)
      .foregroundStyle(Color.fontGrey2)
    }
  }
  
  private var setlistsLayer: some View {
    ForEach(concertInfo.prefix(3), id: \.self) { concert in
      HStack {
        Spacer()
        
        // MARK: Date
        VStack {
          Text(vm.getFormattedDateFromDate(date: concert.setlist.date, format: "yyyy"))
            .foregroundStyle(Color.fontGrey25)
            .tracking(1)
          Text(vm.getFormattedDateFromDate(date: concert.setlist.date, format: "MM.dd"))
        }
        .font(.headline)
        
        Spacer()
        
        // MARK: Venue
        VStack(alignment: .leading) {
          Text(concert.setlist.venue) // MARK: venue name 말고도 city, country를 저장해둬야 할 듯
            .font(.subheadline)
          Text("여기에 뭐가 들어가야 할까용?")
            .font(.footnote)
            .foregroundStyle(Color(hex: 0xC7C7CC)) // MARK: 컬러 값 수정 필요!
        }
        .lineLimit(1)
        .frame(width: screenWidth * 0.5, alignment: .leading)
        .padding(.vertical, 10)
        
        Spacer()
        
        // MARK: Menu Button
        Menu {
          Button {
            // TODO: 여기서 SetlistView를 호출해야 하는데 어떻게 해야할지 잘 모르겠음...
          } label: {
            Text("세트리스트 보기")
          }

          Button {
            vm.dataManager.deleteArchivedConcertInfo(concert)
          } label: {
            Text("공연 북마크 취소")
          }

        } label: {
          Image(systemName: "ellipsis")
            .font(.title3)
        }
        
        Spacer()
      }
      .foregroundStyle(Color.fontBlack)
      
      Divider()
        .padding(.horizontal)
        .foregroundColor(Color.lineGrey1)
    }
  }
  
  private var navigationLayer: some View {
    NavigationLink {
      // TODO: Archiving View + Artist Filter
    } label: {
      HStack {
        Spacer()
        Text("\(vm.artistInfo?.name ?? "") 아카이빙에서 보기")
        Image(systemName: "arrow.right")
      }
      .font(.footnote)
      .padding()
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
        .foregroundStyle(Color.fontBlack)
      Spacer()
    }
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
              .tracking(1.0)
            Text(vm.getFormattedDateFromString(date: setlist.eventDate ?? "", format: "MM.dd") ?? "")
          }
          .font(.headline)
          
          Spacer()
          
          // MARK: Venue
          VStack(alignment: .leading) {
            let venue = "\(setlist.venue?.city?.name ?? ""), \(setlist.venue?.city?.country?.name ?? "")"
            Text(venue)
              .font(.subheadline)
            Group {
              if vm.isEmptySetlist(setlist) {
                Text("세트리스트 정보가 아직 없습니다")
              } else {
                Text("01 ") + Text(setlist.sets?.setsSet?.first?.song?.first?.name ?? "") // TODO: 곡 제목 한글화 필요!
              }
            }
            .font(.footnote)
            .foregroundStyle(Color(hex: 0xC7C7CC)) // TODO: 컬러 값 수정 필요!
          }
          .lineLimit(1)
          .frame(width: screenWidth * 0.5, alignment: .leading)
          .padding(.vertical, 10)
          
          Spacer()
          
          // MARK: Arrow
          Image(systemName: "arrow.right")
            .font(.title3)
          
          Spacer()
        }
        .foregroundStyle(Color.fontBlack)
      }
      
      Divider()
        .padding(.horizontal)
        .foregroundColor(Color.lineGrey1)
    }
  }
  
  private var buttonLayer: some View {
    VStack {
      Button {
        vm.fetchNextPage(artistMbid: vm.artistInfo?.mbid ?? "")
      } label: {
        if vm.isLoading3 {
          ProgressView()
            .padding()
        } else {
          Text("더보기")
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundStyle(Color.fontBlack)
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
  ArtistView(artistName: "IU", artistAlias: "아이유", artistMbid: "b9545342-1e6d-4dae-84ac-013374ad8d7c")
}
