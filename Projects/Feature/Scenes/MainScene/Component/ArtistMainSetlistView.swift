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
            if displaySongs.count > 3 {
                footerView
            }
        }
        .font(.footnote)
        .fontWeight(.semibold)
        .padding()
        .background(
            Rectangle()
                .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
                .foregroundStyle(Color.backgroundWhite)
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
                ListRowView(index: 00, title: "비어있어요")
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
                    .padding(.vertical, 7)

                if index + 1 < (isExpanded ? displaySongs.count : 3) {
                    Divider()
                }
            }
        }
        .padding(.horizontal, 10)
    }

    private var footerView: some View {
        HStack {
            Spacer()
            Text(isExpanded ? "세트리스트 접기" : "세트리스트 전체 보기")
            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
        }
        .onTapGesture {
            isExpanded.toggle()
        }
        .foregroundStyle(Color.fontGrey2)
    }

    private struct ListRowView: View {
        var index: Int?
        var title: String

        var body: some View {
            HStack(alignment: .top, spacing: 16) {
                if let index = index {
                    Text(String(format: "%02d", index))
                        .foregroundStyle(Color.gray)
                } else {
                    Image(systemName: "recordingtape")
                        .foregroundStyle(Color.mainBlack)
                }
                Text(title)
                    .foregroundStyle(Color.mainBlack)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
        }
    }

    private var toastView: some View {
        Text("세트리스트에 추가된 곡이 없어요.\n더보기 - setlist.fm 바로가기에서 곡을 추가하세요")
            .foregroundColor(.white)
            .padding(12)
            .font(.footnote)
            .background(Color.gray)
            .cornerRadius(4)
    }
}
