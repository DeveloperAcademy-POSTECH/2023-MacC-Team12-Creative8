//
//  SearchArtistCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/8/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI
import Core

struct SearchArtistCell: View {
	@Environment(\.colorScheme) var colorScheme
  @Binding var selectedTab: Tab
  let imageURL: String
  let artistName: String
  let artistAlias: String
  let artistMbid: String
  let artistGid: Int
  
  var body: some View {
    VStack(alignment: .leading) {
      NavigationLink(value: NavigationDelivery(artistInfo: SaveArtistInfo(name: artistName, country: "", alias: artistAlias, mbid: artistMbid, gid: artistGid, imageUrl: imageURL, songList: []))) {
        AsyncImage(url: URL(string: imageURL)) { phase in
          switch phase {
          case .empty:
            RoundedRectangle(cornerRadius: 12)
              .overlay(
				Group {
					if colorScheme == .light {
					  Image(uiImage: UIImage(named: "artistViewTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
						.centerCropped()
						.scaledToFill()
						.overlay(
						  RoundedRectangle(cornerRadius: 12)
							.stroke(Color.gray, lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
						)
					} else {
					  Image(uiImage: UIImage(named: "darkArtistViewTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
						.centerCropped()
						.scaledToFill()
						.overlay(
						  RoundedRectangle(cornerRadius: 12)
							.stroke(Color.gray, lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
						)
					}
				}

              )
              .foregroundStyle(Color(UIColor.systemGray5))
          case .success(let image):
            image
              .resizable()
              .scaledToFill()
          case .failure:
            RoundedRectangle(cornerRadius: 12)
              .overlay(
				Group {
					if colorScheme == .light {
					  Image(uiImage: UIImage(named: "artistViewTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
						.centerCropped()
						.scaledToFill()
						.overlay(
						  RoundedRectangle(cornerRadius: 12)
							.stroke(Color.gray, lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
						)
					} else {
					  Image(uiImage: UIImage(named: "darkArtistViewTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
						.centerCropped()
						.scaledToFill()
						.overlay(
						  RoundedRectangle(cornerRadius: 12)
							.stroke(Color.gray, lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
						)
					}
				}

              )
              .foregroundStyle(Color(UIColor.systemGray5))
          @unknown default:
            EmptyView()
          }
        }
      }
      .aspectRatio(contentMode: .fit)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .overlay(RoundedRectangle(cornerRadius: 12)
      .stroke(Color(UIColor.systemGray4), lineWidth: 1))
      
      Text("\(artistName)")
        .foregroundStyle(Color.mainBlack)
        .font(.footnote)
        .lineLimit(1)
    }
  }
}
