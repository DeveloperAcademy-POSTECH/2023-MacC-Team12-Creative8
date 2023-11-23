//
//  ExportPlaylistViewModel.swift
//  Feature
//
//  Created by 장수민 on 11/21/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import Photos
import MusicKit

final class ExportPlaylistViewModel: ObservableObject {
  @Published var playlistTitle: String = ""
  @Published var showYouTubeAlert: Bool = false
  @Published var showAppleMusicAlert: Bool = false
  
  func checkPhotoPermission() -> Bool {
    var status: PHAuthorizationStatus = .notDetermined
    
    if #available(iOS 14, *) {
      status = PHPhotoLibrary.authorizationStatus()
    } else {
      status = PHPhotoLibrary.authorizationStatus()
    }
    return status == .denied
  
  }
  
  func checkMusicKitPermission() -> Bool {
    var status: MusicAuthorization.Status = .notDetermined
    
    status = MusicAuthorization.currentStatus
    
    return status == .denied
  }
  
}
