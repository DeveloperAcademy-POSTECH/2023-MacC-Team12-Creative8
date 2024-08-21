//
//  AllSetlistsView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct AllSetlistsView: View {
  @ObservedObject var vm: ArtistViewModel
  
  var body: some View {
    VStack {
      titleLayer
      if vm.setlists?.count == 0 {
        emptyLayer
      } else {
        setlistsLayer
        if vm.page != vm.totalPage {
          buttonLayer
        }
      }
    }
  }
  
//  private var emptyLayer: some View {
//    VStack {
//      Text("등록된 공연이 없어요")
//        .font(.headline)
//        .fontWeight(.semibold)
//        .padding(.top, UIHeight * 0.1)
//        .padding(.bottom, 5)
//      Text("공연과 세트리스트를 직접 등록하고 싶으신가요?")
//        .multilineTextAlignment(.center)
//        .font(.footnote)
//        .foregroundStyle(Color.gray)
//      HStack(spacing: 0) {
//        Link(destination: URL(string: "https://www.setlist.fm")!) {
//          Text("Setlist.fm")
//            .underline()
//        }
//        Text("에서 추가하세요.")
//      }
//      .foregroundStyle(Color.gray)
//      .font(.footnote)
//    }
//  }
  private var emptyLayer: some View {
    VStack {
      Text("등록된 공연이 없어요")
        .font(.headline)
        .fontWeight(.semibold)
        .padding(.top, UIHeight * 0.1)
        .padding(.bottom, 5)
      Text("공연과 세트리스트를 직접 등록하고 싶으신가요?")
        .multilineTextAlignment(.center)
        .font(.footnote)
        .foregroundStyle(Color.gray)
      HStack(spacing: 0) {
        if vm.isKorean() {
          Link(destination: URL(string: "https://www.setlist.fm")!) {
            Text("Setlist.fm")
              .underline()
          }
          Text("에서 추가하세요.")
        } else {
          Text("setlist? Add it on ")
          Link(destination: URL(string: "https://www.setlist.fm")!) {
            Text("Setlist.fm.")
              .underline()
          }
        }
      }
      .foregroundStyle(Color.gray)
      .font(.footnote)
    }
  }
  
  private var titleLayer: some View {
    HStack {
      Text("전체 공연")
        .font(.headline)
        .fontWeight(.bold)
        .foregroundStyle(Color.mainBlack)
      Spacer()
    }
    .padding(EdgeInsets(top: 16, leading: 24, bottom: 24, trailing: 24))
  }
  
  private var setlistsLayer: some View {
    ForEach(vm.setlists ?? [], id: \.id) { setlist in
      NavigationLink {
        SetlistView(setlist: setlist, artistInfo: vm.artistInfo)
      } label: {
        HStack {
          // MARK: Date
          VStack {
            Text(vm.getFormattedDate(date: setlist.eventDate ?? "", format: "yyyy") ?? "")
              .foregroundStyle(Color(UIColor.systemGray2))
              .tracking(0.5)
            Text(vm.getFormattedDate(date: setlist.eventDate ?? "", format: "MM.dd") ?? "")
              .foregroundStyle(Color.mainBlack)
          }
          .font(.headline)
          
          Spacer()
          
          // MARK: Venue
          VStack(alignment: .leading) {
            let venue = "\(setlist.venue?.city?.name ?? ""), \(setlist.venue?.city?.country?.name ?? "")"
            Text(venue)
              .font(.subheadline)
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
            .foregroundStyle(Color(UIColor.systemGray3))
          }
          .lineLimit(1)
          .frame(width: UIWidth * 0.5, alignment: .leading)
          .padding(.vertical, 10)
          
          Spacer()
          
          // MARK: Arrow
          Image(systemName: "chevron.right")
            .font(.title3)
            .foregroundStyle(Color.mainBlack)
        }
        .padding(.horizontal, 24)
      }
      
      Divider()
        .padding(.horizontal, 24)
        .foregroundColor(Color(UIColor.systemGray3))
    }
  }
  
  private var buttonLayer: some View {
    VStack {
      Button {
        vm.fetchNextPage(artistMbid: vm.artistInfo.mbid)
      } label: {
        if vm.isLoadingNextPage {
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
        .foregroundStyle(Color(UIColor.systemGray3))
        .padding(.horizontal)
    }
  }
  
}

//private struct EmptyView: View {
//  @ObservedObject var vm: ArtistViewModel
//  
//  var body: some View {
//    VStack(alignment: .leading, spacing: 0) {
//      Group {
//        Text("세트리스트 정보가 없습니다.")
//          .font(.system(size: 16))
//          .fontWeight(.semibold)
//          .foregroundStyle(Color.black)
//          .multilineTextAlignment(.leading)
//        
//        Text("찜한 가수의 세트리스트가 없다면,")
//          .foregroundStyle(Color.gray)
//          .font(.footnote)
//          .padding(.top)
//          .multilineTextAlignment(.leading)
//        
//        if vm.isKorean() {
//          HStack(spacing: 0) {
//            Link(destination: URL(string: "https://www.setlist.fm")!) {
//              Text("Setlist.fm")
//                .underline()
//                .foregroundStyle(Color.gray)
//                .font(.footnote)
//            }
//            Text("에서 직접 추가할 수 있어요.")
//              .foregroundStyle(Color.gray)
//              .font(.footnote)
//              .multilineTextAlignment(.leading)
//          }
//          .padding(.bottom)
//        } else {
//          HStack(spacing: 0) {
//            Text("에서 직접 추가할 수 있어요.")
//              .foregroundStyle(Color.gray)
//              .font(.footnote)
//              .multilineTextAlignment(.leading)
//            Link(destination: URL(string: "https://www.setlist.fm")!) {
//              Text("Setlist.fm")
//                .underline()
//                .foregroundStyle(Color.gray)
//                .font(.footnote)
//            }
//          }
//          .padding(.bottom)
//        }
//      }
//      .padding(.horizontal, 3)
//      
//      Link(destination: URL(string: "https://www.setlist.fm")!) {
//        RoundedRectangle(cornerRadius: 14)
//          .foregroundStyle(Color.gray)
//          .frame(height: UIHeight * 0.06)
//          .overlay {
//            Text("세트리스트 추가하기")
//              .foregroundStyle(Color.mainBlack)
//              .bold()
//          }
//          .padding(.top)
//      }
//    }
//    .frame(width: UIWidth * 0.81)
//    .padding(.vertical, 50)
//  }
//  
//}

#Preview {
  AllSetlistsView(vm: ArtistViewModel())
}
