//
//  ArchivingView.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

struct ArchivingView: View {
  @Query(sort: \LikeArtist.orderIndex) var likeArtist: [LikeArtist]
	@Query(sort: \ArchivedConcertInfo.setlist.date, order: .reverse) var concertInfo: [ArchivedConcertInfo]
	@StateObject var viewModel = ArchivingViewModel()

  var body: some View {
    VStack {
        Divider()
        segmentedButtonsView
        if viewModel.selectSegment {
          bookmarkView
        } else {
          artistView
      }
    }
    .padding()
    .navigationTitle("보관함")
  }
}

#Preview {
  NavigationStack {
    ArchivingView()
  }
}

extension ArchivingView {
  private var segmentedButtonsView: some View {
    HStack {
        Button("북마크한 공연") {
          viewModel.selectSegment = true
        }
        .foregroundStyle(viewModel.selectSegment ? Color.fontBlack : Color.fontGrey3)

        Button("찜한 아티스트") {
          viewModel.selectSegment = false
        }
        .foregroundStyle(viewModel.selectSegment ? Color.fontGrey3 : Color.fontBlack)
        .padding(.horizontal)
      }
      .font(.headline)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical)
  }

  private var bookmarkView: some View {
    Group {
      if concertInfo.isEmpty {
        IsEmptyCell(type: .bookmark)
      } else {
        ScrollView {
          bookmarkListView
        }
      }
    }
  }

  private var bookmarkListView: some View {
    VStack {
      ScrollView(.horizontal) {
        HStack {
          ForEach(viewModel.artistSet.sorted(), id: \.self) { artist in
            Button {
              if let index = viewModel.selectArtist.firstIndex(of: artist) {
                viewModel.selectArtist.remove(at: index)
              } else {
                viewModel.selectArtist.insert(artist, at: 0)
              }
            } label: {
              ArtistSetCell(name: artist, isSelected: viewModel.selectArtist.contains(artist))
            }
          }
        }
      }
      .padding(.vertical)

      ForEach(concertInfo) { item in
        if viewModel.selectArtist.isEmpty || viewModel.selectArtist.contains(item.artistInfo.name) {
          ArchiveConcertInfoCell(info: item)
          Divider()
        }
      }
      .padding(.horizontal)
    }
    .onAppear { viewModel.insertArtistSet(concertInfo) }
  }

  private var artistView: some View {
    Group {
      if likeArtist.isEmpty {
        IsEmptyCell(type: .likeArtist)
      } else {
        List {
          Text("찜한 아티스트 중. 상단의 5명만 메인에 등장합니다\n변경을 원하신다면 편집을눌러 순서를 옮겨보세요")
            .font(.footnote)
            .foregroundStyle(Color.fontGrey2)
            .padding(.top)
          artistListView
            .listRowSeparator(.hidden)
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .padding(EdgeInsets(top: -10, leading: -18, bottom: -10, trailing: -18))
      }
    }
  }

  private var artistListView: some View {
    ForEach(Array(likeArtist.enumerated()), id: \.element) { index, item in
      HStack {
        ArchiveArtistCell(artistUrl: URL(string: item.artistInfo.imageUrl)!, isNewUpdate: false)
        Text("\(item.artistInfo.name)")
          .foregroundStyle(index < 5 ? Color.mainOrange : Color.fontBlack)
          .background(
            NavigationLink("", destination: ArtistView(artistName: item.artistInfo.name,
                                                      artistAlias: item.artistInfo.alias,
                                                      artistMbid: item.artistInfo.mbid))
              .opacity(0)
          )
        Spacer()
        MenuButton(item: item)
      }
    }
    .onMove { source, destination in
      var updatedItems = likeArtist
      updatedItems.move(fromOffsets: source, toOffset: destination)
      for (index, item) in updatedItems.enumerated() { item.orderIndex = index }
    }
  }
}
