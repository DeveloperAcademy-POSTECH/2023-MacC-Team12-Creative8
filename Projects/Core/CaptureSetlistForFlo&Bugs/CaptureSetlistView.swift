//
//  CaptureSetlistView.swift
//  Core
//
//  Created by A_Mcflurry on 10/16/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct CaptureSetlistView: View {
  let song: [String]
  let artist: [String]
  let showingSongCount: Int
  let showingSongLastCount: Int
  let index: Int
  var body: some View {
    ZStack {
      Color.white.ignoresSafeArea()
      Image(systemName: "\(index).circle")
        .font(.system(size: 200))
        .opacity(0.3)

        VStack(alignment: .leading) {
          Text("SETA")
            .font(.largeTitle)
            .opacity(0.3)
            .padding(.horizontal, 30)
          Rectangle()
            .foregroundStyle(.black)
            .frame(height: 1)
          ForEach(showingSongCount..<showingSongLastCount, id: \.self) { index in
              VStack(alignment: .leading) {
                Text("\(song[index])")
                Text("\(artist[index])")
              }
              .padding(.horizontal, 30)
            .foregroundStyle(.black)
            Rectangle()
              .foregroundStyle(.black)
              .frame(height: 1)
          }
        }
        .padding(.top, 30)

    }
  }
}

extension CaptureSetlistView {
  func screenShot() {
    let screenshot = body.takeScreenshot(origin: UIScreen.main.bounds.origin, size: UIScreen.main.bounds.size)
    UIImageWriteToSavedPhotosAlbum(screenshot, self, nil, nil)
  }
}

extension View {
  func takeScreenshot(origin: CGPoint, size: CGSize) -> UIImage {
    let window = UIWindow(frame: CGRect(origin: origin, size: size))
    let hosting = UIHostingController(rootView: self)
    hosting.view.frame = window.frame
    window.addSubview(hosting.view)
    window.makeKeyAndVisible()
    return hosting.view.screenShot
  }
}

extension UIView {
    var screenShot: UIImage {
      let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return capturedImage
    }
}

extension View {
  func takeSetlistToImage(_ song: [String], _ artist: [String]) {
    let songCount = song.count
    let pagesongs = songCount / 10
    let remainsongs = songCount % 10
    let pictureCount = pagesongs + (remainsongs == 0 ? 0 : 1)
    for forI in 0..<pictureCount {
      let captureView = CaptureSetlistView(song: song,
                                           artist: artist,
                                           showingSongCount: 10 * forI,
                                           showingSongLastCount: forI == pictureCount-1 && remainsongs != 0 ?
                                           (10 * forI + remainsongs) : (10 * (forI + 1)),
                                           index: forI+1)
      captureView.screenShot()
    }
  }
}
