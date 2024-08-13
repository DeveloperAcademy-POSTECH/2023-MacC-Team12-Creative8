//
//  ExportPlaylistButtonView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI

struct ExportPlaylistButtonView: View {
    let setlist: Setlist?
    let artistInfo: ArtistInfo?
    @ObservedObject var vm: SetlistViewModel
    @Binding var showToastMessageAppleMusic: Bool
    @Binding var showToastMessageCapture: Bool
    @Binding var showToastMessageSubscription: Bool
    @Binding var showSpotifyAlert: Bool
    @Binding var showCaptureAlert: Bool
    @ObservedObject var exportViewModel: ExportPlaylistViewModel
    
    private func toastMessageToShow() -> LocalizedStringResource? {
        if showToastMessageAppleMusic {
            return "10초 뒤 Apple Music에서 확인하세요"
        } else if showToastMessageCapture {
            return "캡쳐된 이미지를 앨범에서 확인하세요"
        } else if showToastMessageSubscription {
            return "플레이리스트를 내보내려면 Apple Music을 구독해야 합니다"
        } else if showSpotifyAlert {
            return "10초 뒤 Spotify에서 확인하세요"
        } else {
            return nil
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                
                Text("플레이리스트 만들기")
                    .foregroundStyle(Color.mainWhite)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.mainBlack)
                    .cornerRadius(14)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                    .background(Rectangle().foregroundStyle(Color.gray6))
                    .onTapGesture {
                        vm.createArrayForExportPlaylist(setlist: setlist, songList: artistInfo?.songList ?? [], artistName: artistInfo?.name)
                        vm.showModal.toggle()
                    }
                
            }
            if showToastMessageAppleMusic {
                VStack {
                    ToastMessageView(
                        message: "Apple Music으로 세트리스트가 옮겨지고 있어요!",
                        subMessage: "15초 후 완료 예정",
                        icon: "dot.radiowaves.left.and.right",
                        color: Color.toast1
                    )
                    .padding(.horizontal, UIWidth * 0.075)
                    .padding(.top, 5)
                    Spacer()
                }
            }
            
            if showSpotifyAlert {
                VStack {
                    ToastMessageView(
                        message: "Spotify로 세트리스트가 옮겨지고 있어요!",
                        subMessage: "15초 후 완료 예정",
                        icon: "dot.radiowaves.left.and.right",
                        color: Color.toast1
                    )
                    .padding(.horizontal, UIWidth * 0.075)
                    .padding(.top, 5)
                    Spacer()
                }
            }
            
            if showCaptureAlert {
                ZStack {
                    Color.black.opacity(0.6).ignoresSafeArea()
                    captureSetlistAlertView
                        .padding(.bottom, 120)
                }
            }
            
            if showToastMessageCapture {
                VStack {
                    ToastMessageView(
                        message: "캡쳐된 이미지를 앨범에서 확인하세요",
                        subMessage: nil,
                        icon: "checkmark.circle.fill",
                        color: Color.toast1
                    )
                    .padding(.horizontal, UIWidth * 0.075)
                    .padding(.top, 5)
                    Spacer()
                }
            }
            
        }
        .sheet(isPresented: $vm.showModal) {
            BottomModalView(setlist: setlist, artistInfo: artistInfo, exportViewModel: exportViewModel, vm: vm, showToastMessageAppleMusic: $showToastMessageAppleMusic, showCaptureALert: $showCaptureAlert, showSpotifyAlert: $showSpotifyAlert)
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.visible)
        }
    }
    
    private var captureSetlistAlertView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12.0)
                .frame(width: UIWidth * 0.95, height: UIHeight * 0.23)
                .foregroundStyle(Color.white)
            VStack {
                Text("Bugs, FLO, genie, VIBE를 이용하시나요?")
                    .font(.callout.bold())
                    .padding()
                Text("위의 뮤직앱에서는 이미지로 된 세트리스트를\n인식해 플레이리스트로 변환합니다.\n원하는 세트리스트를 이미지로 받아보세요.")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .foregroundStyle(Color.gray)
                Divider()
                    .padding(.vertical, 15)
                HStack {
                    Button {
                        showCaptureAlert = false
                    } label: {
                        Text("취소")
                            .frame(width: UIWidth * 0.95 * 0.5)
                            .font(.callout)
                            .foregroundStyle(Color.black)
                            .padding(.bottom)
                    }
                    Button {
                        exportViewModel.handlePhotoExportButtonAction()
                        if !exportViewModel.checkPhotoPermission() {
                            takeSetlistToImage(vm.setlistSongKoreanName)
                        }
                        showCaptureAlert = false
                        showToastMessageCapture = true
                    } label: {
                        Text("이미지 저장")
                            .frame(width: UIWidth * 0.95 * 0.5)
                            .font(.callout)
                            .fontWeight(.bold)
                            .padding(.bottom)
                    }
                    // 사진 권한 허용 거부 상태인 경우
                    .alert(isPresented: $exportViewModel.showLibrarySettingsAlert) {
                        Alert(
                            title: Text(""),
                            message: Text("사진 기능을 사용하려면 ‘사진/비디오' 접근 권한을 허용해야 합니다."),
                            primaryButton: .default(Text("취소")),
                            secondaryButton: .default(Text("설정").bold(), action: {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }))
                    }
                }
            }
        }
    }
}
