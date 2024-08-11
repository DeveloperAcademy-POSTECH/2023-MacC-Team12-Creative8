//
//  SetlistInfoView.swift
//  Feature
//
//  Created by 고혜지 on 6/29/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI

struct SetlistInfoView: View {
  let imageUrl: String?
  let title: String
  let artistName: String
  let venue: String
  let location: String
  let date: String
  let shareButtonAction: (() -> Void)
  let bookmarkButtonAction: (() -> Void)
  var isBookmarkedSetlist: Bool
  
  var body: some View {
    VStack(spacing: 0) {
      ZStack {
        Rectangle()
          .foregroundStyle(Color.mainWhite)
          .cornerRadius(12.0, corners: [.topLeft, .topRight])
        
        HStack {
          if let imageUrl = imageUrl {
            AsyncImage(url: URL(string: imageUrl)) { image in
              image
                .centerCropped()
                .cornerRadius(12.0)
                .overlay(Color.black.opacity(0.2).cornerRadius(14))
            } placeholder: {
              ProgressView()
            }
            .frame(width: UIWidth * 0.9 * 0.38, height: UIWidth * 0.9 * 0.38)
          } else {
            Image("artistViewTicket", bundle: Bundle(identifier: "com.creative8.seta.UI"))
              .resizable()
              .frame(width: UIWidth * 0.9 * 0.38, height: UIWidth * 0.9 * 0.38)
          }
          
          VStack(alignment: .leading) {
            Text(title)
              .font(.headline)
              .foregroundStyle(Color.mainBlack)
              .padding(.bottom, 2)
            Text(artistName)
              .font(.callout)
              .foregroundStyle(Color.mainBlack)
              .padding(.bottom, 2)
            Text(venue)
              .font(.footnote)
              .foregroundStyle(Color(UIColor.systemGray))
            Text(location)
              .font(.footnote)
              .foregroundStyle(Color(UIColor.systemGray))
              .padding(.bottom, 7)
            HStack(spacing: 3) {
              Image(systemName: "calendar")
              Text(date)
            }
            .font(.footnote)
            .fontWeight(.semibold)
            .foregroundStyle(Color.mainOrange)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.orange100)
            .cornerRadius(20)
          }
          .lineLimit(1)
          .frame(width: UIWidth * 0.9 * 0.5, height: UIWidth * 0.9 * 0.35)
        }
        
      }
      .frame(width: UIWidth * 0.9)
      .aspectRatio(2.3, contentMode: .fit)
      
      Rectangle()
        .frame(width: UIWidth * 0.9, height: 2)
        .foregroundStyle(Color.gray6)
      
      ZStack {
        Rectangle()
          .foregroundStyle(Color.mainWhite)
          .cornerRadius(12.0, corners: [.bottomLeft, .bottomRight])
        HStack {
          Spacer()
          Button {
            shareButtonAction()
          } label: {
            HStack {
              Image(systemName: "square.and.arrow.up")
              Text("공유")
            }
            .foregroundStyle(Color(UIColor.systemGray))
          }
          Spacer()
          Rectangle()
            .frame(width: 2)
            .foregroundStyle(Color.gray6)
          Spacer()
          Button {
            bookmarkButtonAction()
          } label: {
            HStack {
              Image(systemName: isBookmarkedSetlist ? "bookmark.fill" : "bookmark")
              Text("저장")
            }
            .foregroundStyle(Color.mainOrange)
          }
          Spacer()
        }
        .font(.callout)
        .fontWeight(.semibold)
      }
      .frame(width: UIWidth * 0.9)
      .aspectRatio(6.0, contentMode: .fit)
    }
  }
}

#Preview {
  ZStack {
    Color.gray.ignoresSafeArea()
    VStack {
      SetlistInfoView(
        imageUrl: "https://images.genius.com/52e84f5a1e618f9f72c763a920ba788a.1000x1000x1.jpg",
        title: "POWER ANDRE 99",
        artistName: "Silica Gel",
        venue: "Blue Square Mastercard Hall",
        location: "Seoul, South Korea",
        date: "2023년 11월 12일",
        shareButtonAction: {},
        bookmarkButtonAction: {},
        isBookmarkedSetlist: true
      )
      SetlistInfoView(
        imageUrl: nil,
        title: "POWER ANDRE 99",
        artistName: "Silica Gel",
        venue: "Blue Square Mastercard Hall",
        location: "Seoul, South Korea",
        date: "2023년 11월 12일",
        shareButtonAction: {},
        bookmarkButtonAction: {},
        isBookmarkedSetlist: false
      )
      Spacer()
    }
  }
}
