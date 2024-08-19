//
//  SummarizedSetlistInfoView.swift
//  Feature
//
//  Created by 고혜지 on 5/23/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI

struct SummarizedSetlistInfoView: View {
  let type: ComponentType
  let info: SetlistInfo?
  let infoButtonAction: (() -> Void)?
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
        .foregroundStyle(Color.mainWhite)
    )
    .frame(width: UIWidth * 0.87)
  }
  
  // MARK: - Title View
  private var titleView: some View {
    HStack {
      Text(type == .recentConcert ? "최근 공연" : "북마크한 공연")
      Spacer()
    }
    .foregroundStyle(Color.gray)
    .fontWeight(.semibold)
    .padding(10)
    .background(
      RoundedRectangle(cornerRadius: 4)
        .foregroundStyle(Color(UIColor.systemGray5))
    )
  }
  
  // MARK: - No Info View
  private var noInfoView: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(info == nil && type == .recentConcert ? "등록된 공연이 없어요" : "좋아하는 공연을 북마크 해보세요.")
        .foregroundStyle(info == nil && type == .recentConcert ? Color.mainBlack : Color(UIColor.systemGray3))
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
        Text(info.title.isEmpty ? "\(info.artistInfo.name)의 Setlist" : info.title)
          .foregroundStyle(Color.mainBlack)
          .font(.callout)
          .padding(.horizontal, 5)
        Text(info.venue)
          .multilineTextAlignment(.leading)
          .fontWeight(.regular)
          .foregroundStyle(Color(UIColor.systemGray2))
          .padding(.horizontal, 5)
      }
      
      // MARK: Navigation
      navigationView
    }
  }
  
  // MARK: - Date View
  private var dateView: some View {
    HStack {
      HStack(spacing: 3) {
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
    }
    .padding(.top, -6)
  }
  
  // MARK: - Navigation View
  private var navigationView: some View {
    HStack {
      Spacer()
      if type == .bookmarkedConcert {
        Text("보관함에서 보기")
        Image(systemName: "chevron.right")
          .foregroundStyle(Color(UIColor.systemGray3))
      }
      
    }
    .foregroundStyle(Color.gray)
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
    
    // 1. 북마크한 공연 & 정보 O
    SummarizedSetlistInfoView(
      type: .bookmarkedConcert,
      info: SetlistInfo(
        artistInfo: ArtistInfo(
          name: "Post Malone",
          mbid: ""
        ),
        id: "",
        date: "2023년 11월 12일",
        title: "Main Concert Title",
        venue: "Venue Name\nCity, Country"
      ),
      infoButtonAction: nil,
      chevronButtonAction: nil
    )
    
    //    // 2. 북마크한 공연 & 정보 X
    //    SummarizedSetlistInfoView(
    //      type: .bookmarkedConcert,
    //      info: nil,
    //      infoButtonAction: nil,
    //      chevronButtonAction: nil
    //    )
    //
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
    //      chevronButtonAction: nil
    //    )
    //
    //    // 4. 최근 공연 & 정보 X
    //    SummarizedSetlistInfoView(
    //      type: .recentConcert,
    //      info: nil,
    //      infoButtonAction: nil,
    //      chevronButtonAction: nil
    //    )
    
  }
}
