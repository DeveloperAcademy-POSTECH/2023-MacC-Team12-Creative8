//
//  ShareSetlistView.swift
//  Core
//
//  Created by 예슬 on 2023/11/17.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UIKit

struct ShareSetlistView: View {
  
  let song: [String]
  let artist: String
  let songCount: Int
  
  var body: some View {
    ZStack {
      Color.white.ignoresSafeArea()
      VStack(alignment: .leading) {
        Text("Seta")
          .font(.system(size: 15))
          .opacity(0.3)
          //.padding(.horizontal, 30)
        Text("\(artist) Setlist")
        
        if songCount <= 25 {
          VStack {
            ForEach(0..<songCount, id: \.self) { index in
              HStack {
                Text(String(format: "%02d", index + 1))
                Text("\(song[index])")
              }
            }
          }
        } else {
          HStack {
            VStack {
              ForEach(0..<25, id: \.self) { index in
                HStack {
                  Text(String(format: "%02d", index + 1))
                  Text("\(song[index])")
                }
              }
            }
            VStack {
              ForEach(25..<songCount, id: \.self) { index in
                HStack {
                  Text(String(format: "%02d", index + 1))
                  Text("\(song[index])")
                }
              }
            }
          }
        }
      }
    }
    //.padding(.top, 30)
  }
}

extension ShareSetlistView {
  func setlistImage() -> UIImage {
    let setlistImage = body.createSetlistImage(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size)
    return setlistImage
  }
}

extension View {
  func createSetlistImage(origin: CGPoint, size: CGSize) -> UIImage {
    let window = UIWindow(frame: CGRect(origin: origin, size: size))
    let hosting = UIHostingController(rootView: self)
    hosting.view.frame = window.frame
    window.addSubview(hosting.view)
    window.makeKeyAndVisible()
    return hosting.view.setlistImage
  }
}

extension UIView {
  var setlistImage: UIImage {
    let rect = self.bounds
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    let context: CGContext = UIGraphicsGetCurrentContext()!
    self.layer.render(in: context)
    let shareImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    return shareImage
  }
}

public extension View {
  func shareSetlistToImage(_ song: [String], _ artist: String) -> UIImage {
    let songCount = song.count // 15 ,45, 50
    let firstSectionSongs = songCount / 25 // 0, 1, 2
    let secondSectionSongs = songCount % 25 // 15, 20, 0
    let sectionCount = firstSectionSongs + (firstSectionSongs < 2 ? 1 : 0 ) // 1, 1, 2
    let captureView = ShareSetlistView(song: song,
                                       artist: artist,
                                       songCount: songCount)
    return captureView.setlistImage()
  }
}
