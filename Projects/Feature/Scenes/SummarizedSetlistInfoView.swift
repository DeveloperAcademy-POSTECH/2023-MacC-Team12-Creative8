//
//  SummarizedSetlistInfoView.swift
//  Feature
//
//  Created by 고혜지 on 5/23/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core

struct SummarizedSetlistInfoView: View {
    let type: ComponentType
    let info: SetlistInfo?
    let infoButtonAction: (() -> Void)?
    let cancelBookmarkAction: (() -> Void)?
    let chevronButtonAction: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleView
            
            if info == nil {
                noInfoView
            } else {
                infoView
            }
        }
        .font(.footnote)
        .fontWeight(.semibold)
        .padding()
        .background(
            Rectangle()
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .foregroundStyle(Color.backgroundWhite)
        )
        .padding(.horizontal)
    }
    
    // MARK: - Title View
    private var titleView: some View {
        HStack {
            Text(type == .recentConcert ? "최근 공연" : "북마크한 공연")
            Spacer()
        }
        .foregroundStyle(Color.fontGrey2)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(Color.mainGrey1)
        )
    }
    
    // MARK: - No Info View
    private var noInfoView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(info == nil && type == .recentConcert ? "등록된 공연이 없어요" : "좋아하는 공연을 북마크 해보세요.")
                .foregroundStyle(Color.black)
                .font(.headline).bold()
            
            if type == .recentConcert {
                Text("공연과 세트리스트를 직접 등록하고 싶으신가요?\n")
                + Text("[Setlist.fm](https://www.setlist.fm/)").underline()
                + Text("에서 추가하세요.")
            }
        }
        .foregroundStyle(Color.gray)
        .padding(5)
        .padding(.bottom, 30)
    }
    
    // MARK: - Info View
    private var infoView: some View {
      VStack(alignment: .leading, spacing: 10) {
            dateView
            
            // MARK: Concert Info
            if let info = info {
                Text(info.title)
                    .foregroundStyle(Color.mainBlack)
                    .font(.callout)
                    .padding(5)
                Text(info.venue)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.fontGrey2)
                    .padding(.horizontal, 5)
            }
            
            // MARK: Navigation
            navigationView
        }
    }
    
    // MARK: - Date View
    private var dateView: some View {
        HStack {
            HStack {
                Image(systemName: "calendar")
                Text(info?.date ?? "-")
            }
            .foregroundStyle(Color.mainOrange)
            .padding(6)
            .padding(.horizontal, 2)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.mainOrange.opacity(0.1))
            )
            
            Spacer()
            
            menuButton
                .opacity(type == .bookmarkedConcert && info != nil ? 1 : 0)
        }
        .padding(.top, -6)
    }
    
    // MARK: - Menu Button
    private var menuButton: some View {
        Menu {
            NavigationLink {
                SetlistView(
                    setlistId: info?.id,
                    artistInfo: info?.artistInfo ?? ArtistInfo(name: "", mbid: "")
                )
            } label: {
                Text("세트리스트 보기")
            }
            Button {
                cancelBookmarkAction?()
            } label: {
                Text("북마크 취소")
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.mainBlack)
                .padding(.trailing, 10)
        }
    }
    
    // MARK: - Navigation View
    private var navigationView: some View {
        HStack {
            Spacer()
            
            switch type {
            case .recentConcert:
                Text("공연 모두 보기")
            case .bookmarkedConcert:
                Text("보관함에서 보기")
            }
            
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(Color.fontGrey2)
        .onTapGesture {
            chevronButtonAction?()
        }
    }
}

enum ComponentType {
    case recentConcert
    case bookmarkedConcert
}

struct SetlistInfo {
    var artistInfo: ArtistInfo
    var id: String
    var date: String
    var title: String
    var venue: String
}


#Preview {
  ZStack {
    Color.gray.ignoresSafeArea()
    
    //    // 1. 북마크한 공연 & 정보 O
    //    SummarizedSetlistInfoView(
    //      type: .bookmarkedConcert,
    //      info: SetlistInfo(
    //        artistInfo: ArtistInfo(
    //          name: "Post Malone",
    //          mbid: ""
    //        ),
    //        id: "",
    //        date: "2023년 11월 12일",
    //        title: "Main Concert Title",
    //        venue: "Venue Name\nCity, Country"
    //      ),
    //      infoButtonAction: nil,
    //      cancelBookmarkAction: nil,
    //      chevronButtonAction: nil
    //    )
    
    //    // 2. 북마크한 공연 & 정보 X
    //    SummarizedSetlistInfoView(
    //      type: .bookmarkedConcert,
    //      info: nil,
    //      infoButtonAction: nil,
    //      cancelBookmarkAction: nil,
    //      chevronButtonAction: nil
    //    )
    
    //    // 3. 최근 공연 & 정보 O
    //    SummarizedSetlistInfoView(
    //      type: .recentConcert,
    //      info: SetlistInfo(
    //        artistInfo: ArtistInfo(
    //          name: "Post Malone",
    //          mbid: ""
    //        ),
    //        id: "",
    //        date: "2023년 11월 12일",
    //        title: "Main Concert Title",
    //        venue: "Venue Name\nCity, Country"
    //      ),
    //      infoButtonAction: nil,
    //      cancelBookmarkAction: nil,
    //      chevronButtonAction: nil
    //    )
    
    // 4. 최근 공연 & 정보 X
    SummarizedSetlistInfoView(
      type: .recentConcert,
      info: nil,
      infoButtonAction: nil,
      cancelBookmarkAction: nil,
      chevronButtonAction: nil
    )
    
  }
}
