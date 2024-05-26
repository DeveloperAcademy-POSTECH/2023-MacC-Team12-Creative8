//
//  SetlistImageShareView.swift
//  Feature
//
//  Created by 예슬 on 5/12/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core

struct SetlistImageShareView: View {
  let artistInfo: ArtistInfo?
  let setlist: Setlist?
  @StateObject var viewModel: SetlistViewModel
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.black.ignoresSafeArea()
      ScrollView {
        VStack {
          HStack {
            Button(action: {
              
            }, label: {
              Image(systemName: "xmark")
                .foregroundStyle(.white)
            })
            .padding(.leading, 8)
            .padding(.trailing, 133)
            Text("공유하기")
              .font(.headline)
              .foregroundStyle(.white)
            Spacer()
          }
          .padding(.bottom, 27)
          
          let image = shareSetlistToImage(viewModel.setlistSongKoreanName, artistInfo?.name ?? "", setlist)
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: UIWidth * 0.54, height: UIHeight * 0.44)
            .background(.blue)
            .padding(.bottom, 83)
          
          List {
            Button(action: {
              
            }, label: {
              HStack {
                Text("인스타그램 스토리")
                Spacer()
                Image(systemName: "star")
              }
              .foregroundStyle(.black)
            })
            .padding(.vertical, 8)
            
            Button(action: {
              
            }, label: {
              HStack {
                Text("이미지 저장")
                Spacer()
                Image(systemName: "square.and.arrow.down")
              }
              .foregroundStyle(.black)
            })
            .padding(.vertical, 8)
            
            Button(action: {
              
            }, label: {
              HStack {
                Text("옵션 더보기")
                Spacer()
                Image(systemName: "ellipsis")
              }
              .foregroundStyle(.black)
            })
            .padding(.vertical, 8)
          }
          .listStyle(.plain)
          .frame(height: UIHeight * 0.206)
          .background(.red)
          .cornerRadius(16)
          .scrollDisabled(true)
          .padding(.horizontal, 24)
          
          Button(action: {
            
          }, label: {
            HStack {
              Text("취소하기")
              Spacer()
              Image(systemName: "xmark")
            }
            .foregroundStyle(.white)
            .padding(EdgeInsets(top: 19, leading: 20, bottom: 19, trailing: 20))
          })
          .background(.white.opacity(0.32))
          .cornerRadius(12)
          .padding(.horizontal, 24)
        }
      }
    }
    .navigationTitle("공유하기")
  }
}

#Preview {
  SetlistImageShareView(artistInfo: ArtistInfo(name: "Silica Gel", alias: "실리카겔", mbid: "2c8b5bb2-6110-488d-bc15-abb08379d3c6", gid: 2382659, imageUrl: "https://i.namu.wiki/i/SCZmC5XQgajMHRv6wvMc406r6aoQyf0JjXNCIQkIxJ-oe035C8h6VTkKllE6gkp3p-A7RFwiIcd0d726O77rbQ.webp", songList: []), setlist: Setlist(id: "4bab53aa", versionId: "g2bbec082", eventDate: "19-05-2024", lastUpdated: "2024-04-10T05:05:20.328+0000", artist: Artist(mbid: "2c8b5bb2-6110-488d-bc15-abb08379d3c6", name: "Silica Gel", sortName: "Silica Gel", disambiguation: "Korean band", url: "https://www.setlist.fm/setlists/silica-gel-5bfc9394.html"), venue: nil, sets: nil, url: nil, info: nil, tour: nil), viewModel: SetlistViewModel())
}
