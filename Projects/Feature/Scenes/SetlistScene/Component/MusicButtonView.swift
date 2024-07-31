//
//  MusicButtonView.swift
//  Feature
//
//  Created by A_Mcflurry on 7/14/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct MusicButtonView: View {
  let music: MusicCases
  var body: some View {
    VStack {
      Image(music.rawValue, bundle: setaBundle)
        .resizable()
        .frame(width: 40, height: 40)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 21)
        .background(Color.gray6)
        .clipShape(RoundedRectangle(cornerRadius: 14))
      
      Text(music.name)
        .font(.system(size: 15))
        .foregroundStyle(Color.black)
        .opacity(0.6)
    }
      
  }
    
  enum MusicCases: String {
    case appleMusic
    case spotify
    
    var name: String {
      switch self {
      case .appleMusic:
        return "Apple Music"
      case .spotify:
        return "Spotify"
      }
    }
  }
}

#Preview {
  HStack {
    MusicButtonView(music: .appleMusic)
    MusicButtonView(music: .spotify)
  }
  .padding()
}
