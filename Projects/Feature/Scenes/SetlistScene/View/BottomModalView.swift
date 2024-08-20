//
//  BottomModalView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI
import UIKit

struct BottomModalView: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @ObservedObject var exportViewModel: ExportPlaylistViewModel
  @ObservedObject var vm: SetlistViewModel
  @StateObject var spotifyManager = SpotifyManager.shared
  @Binding var showToastMessageAppleMusic: Bool
  @Binding var showCaptureALert: Bool
  @Binding var showSpotifyAlert: Bool
  @State var isSharePresented = false
  
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        artistInfoView
          .padding(.top)
        Divider()
          .padding(.vertical, UIHeight * 0.01)
        HStack {
          appleMusicButtonView
          spotifyButtonView
        }
        captureSetListButtonView
          .padding()
      }
      .padding(.horizontal)
      .background(Color.mainWhite)
    }
  }
  
  func isKorean() -> Bool {
    guard let languageCode = Locale.current.language.languageCode?.identifier else { return false }
    return languageCode == "ko"
  }
  
  private var spotifyButtonView: some View {
    Button {
      spotifyManager.addPlayList(name: setlist?.artist?.name ?? "",
                                 musicList: vm.setlistSongName,
                                 venue: setlist?.venue?.name ?? "") {
        vm.showModal.toggle()
        showSpotifyAlert.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          self.showSpotifyAlert = false
        }
      }
    } label: {
      MusicButtonView(music: .spotify)
    }.onOpenURL(perform: spotifyManager.handleURL(_:))
    
  }
  
  private var artistInfoView: some View {
    HStack(alignment: .top) {
      Group {
        if let imageUrl = artistInfo?.imageUrl {
          AsyncImage(url: URL(string: imageUrl)) { image in
            image
              .centerCropped()
              .cornerRadius(12.0)
          } placeholder: {
            ProgressView()
          }
          .frame(width: UIWidth * 0.18, height: UIWidth * 0.18)
          .padding(.trailing, 10)
        } else {
          Image("artistViewTicket", bundle: Bundle(identifier: "com.creative8.seta.UI"))
            .resizable()
            .frame(width: UIWidth * 0.18, height: UIWidth * 0.18)
            .padding(.trailing, 10)
        }
        
        VStack(alignment: .leading) {
          Text(artistInfo?.name ?? "")
            .lineLimit(1)
            .font(.headline)
            .fontWeight(.regular)
          if vm.isKorean() {
            Text(setlist?.tour?.name ?? "\(artistInfo?.name ?? "")의 세트리스트")
              .lineLimit(1)
              .font(.footnote)
          } else {
            Text(setlist?.tour?.name ?? "\(artistInfo?.name ?? "")'s playlist")
              .lineLimit(1)
              .font(.footnote)
          }
          Text("\(setlist?.venue?.city?.country?.name ?? "-"), \(setlist?.venue?.city?.name ?? "-") • \(vm.allDateFormatter(inputDate: setlist?.eventDate?.description ?? "") ?? "-")")
            .lineLimit(1)
            .font(.footnote)
            .foregroundStyle(Color.gray)
        }
        .frame(width: UIWidth * 0.5)
        .padding(.trailing)
        .padding(.top, UIHeight * 0.007)
      }
      .padding(.top)

      Spacer()
      
      Button {
        vm.showModal = false
      } label: {
        Image("modalCloseButton", bundle: Bundle(identifier: "com.creative8.seta.UI"))
          .resizable()
          .frame(width: UIWidth * 0.08, height: UIWidth * 0.08)
      }
      .sheet(isPresented: $isSharePresented, content: {
        SetlistImageShareView(artistInfo: artistInfo, setlist: setlist, viewModel: vm)
      })
    }
  }
  
  private var appleMusicButtonView: some View {
    Button {
      exportViewModel.handleAppleMusicButtonAction()
      vm.showModal.toggle()
    } label: {
      MusicButtonView(music: .appleMusic)
    }
    // 애플뮤직 권한 허용 거부 상태인 경우
    .alert(isPresented: $exportViewModel.showMusicSettingsAlert) {
      Alert(
        title: Text(""),
        message: Text("플레이리스트 내보내기 기능을 사용하려면 ‘Apple Music' 접근 권한을 허용해야 합니다."),
        primaryButton: .default(Text("취소")),
        secondaryButton: .default(Text("설정").bold(), action: {
          UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
    }
  }
  
  private var captureSetListButtonView: some View {
    Button(action: {
      vm.showModal = false
      showCaptureALert = true
    }, label: {
      Text("Bugs, FLO, genie, VIBE를 이용하시나요?")
        .font(.callout)
        .foregroundStyle(Color.blue)
    })
  }
  
  private func platformButtonView(title: String, image: String, action: @escaping () -> Void) -> some View {
    Button {
      action()
    } label: {
      VStack(spacing: 0) {
        ZStack {
          RoundedRectangle(cornerRadius: 14)
            .foregroundStyle(Color.gray)
            .frame(maxWidth: .infinity)
            .frame(height: UIWidth * 0.2)
          
          Image(image, bundle: setaBundle)
            .resizable()
            .scaledToFit()
            .frame(width: UIWidth * 0.1)
          
        }
        .padding(.bottom, 11)
        
        Text(title)
          .font(.caption2)
          .foregroundStyle(Color.mainBlack)
      }
    }
  }
}
