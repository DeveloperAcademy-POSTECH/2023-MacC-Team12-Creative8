//
//  ArtistMainSetlistView.swift
//  Feature
//
//  Created by 최효원 on 7/16/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core

struct ArtistMainSetlistView: View {
    @State private var isExpanded = false
    @StateObject var viewModel: MainViewModel
    @State private var showToast = false
    let index: Int

    private var displaySongs: [Song] {
        guard let firstSetlist = viewModel.setlists[index]?.first else {
            return []
        }
      return firstSetlist?.sets?.setsSet?.flatMap { $0.song ?? [] } ?? []
    }

    var body: some View {
        VStack {
            headerView
            Spacer().frame(height: 25)
            setlistContent
                .padding(.bottom, 25)
            if displaySongs.count > 3 {
                footerView
                    .padding(.bottom, 5)
            }
        }
        .font(.footnote)
        .fontWeight(.semibold)
        .padding()
        .background(
            Rectangle()
                .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
                .foregroundStyle(Color.mainWhite)
        )
        .padding(.horizontal)
        .overlay(
            showToast ? toastView.padding([.horizontal], 22).padding(.top, 40) : nil,
            alignment: .top
        )
    }

    private var headerView: some View {
        HStack {
            Text("세트리스트")
                .foregroundStyle(Color.mainOrange)
            Spacer()
            if displaySongs.isEmpty {
                infoButton
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(Color.mainOrange.opacity(0.1))
        )
    }

    private var infoButton: some View {
        Button {
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showToast = false
            }
        } label: {
            Image(systemName: "info.circle")
                .foregroundStyle(Color.gray)
        }
    }

    private var setlistContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            if displaySongs.isEmpty {
                ListRowView(index: 00, title: "포함된 곡이 없어요")
                    .padding(.horizontal, 8)
            } else {
                songList
            }
        }
    }

    private var songList: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            ForEach(Array(displaySongs.prefix(isExpanded ? displaySongs.count : 3).enumerated()), id: \.offset) { index, song in
                ListRowView(index: song.tape == true ? nil : index + 1, title: song.name ?? "")
                    .opacity(song.tape == true ? 0.6 : 1.0)
                    .padding(3)
                
                if displaySongs.count > 1 {
                    if index + 1 < (isExpanded ? displaySongs.count : 3) {
                        Divider()
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }

    private var footerView: some View {
        HStack {
            Spacer()
            Text(isExpanded ? "세트리스트 접기" : "세트리스트 전체 보기")
              .foregroundStyle(Color.gray)
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
              .foregroundStyle(Color(UIColor.systemGray3))
        }
        .padding(.trailing, 5)
        .onTapGesture {
            isExpanded.toggle()
        }
    }

    private struct ListRowView: View {
        var index: Int?
        var title: String

        var body: some View {
            HStack(alignment: .top, spacing: 16) {
                if let index = index {
                    Text(String(format: "%02d", index))
                    .foregroundStyle(Color(UIColor.systemGray2))
                } else {
                    Image(systemName: "recordingtape")
                        .foregroundStyle(Color.mainBlack)
                }
                Text(title)
                    .foregroundStyle(Color.mainBlack)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var toastView: some View {
        VStack(alignment: .leading) {
            Text("아티스트의 최근 공연 세트리스트가 없어요\n")
            Text("더보기 - setlist.fm 바로가기에서 곡을 추가하세요")
        }
        .foregroundColor(.mainWhite)
        .padding(12)
        .font(.footnote)
        .background(Color.toastBG)
        .cornerRadius(4)
    }
}
