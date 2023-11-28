//
//  ShareSetlistView.swift
//  Core
//
//  Created by 예슬 on 2023/11/17.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI

struct ShareSetlistView: View {
  //let setlist: Setlist?
  let songList: [(String, String?)]
  let artist: String
  let songCount: Int
  
  //@ObservedObject var vm: ArtistViewModel
  
  var body: some View {
    ScrollView {
      VStack(spacing: -1) {
        ZStack{
          Rectangle()
            .cornerRadius(20)
            .foregroundStyle(.white)
            .frame(width: 1080, height: 589)
          VStack(alignment: .leading) {
            Text(artist)
              .font(.system(size: 50))
              .padding(.top, 50)
            Rectangle()
              .foregroundStyle(.black)
              .frame(height: 1)
            Text("tourrrrrrrrr")
              .font(.system(size: 50))
            //          Text(setlist?.tour?.name ?? "-")
            Rectangle()
              .foregroundStyle(.black)
              .frame(height: 1)
            //          let venue = "\(setlist?.venue?.name ?? ""), \(setlist?.venue?.city?.name ?? ""), \(setlist?.venue?.city?.country?.name ?? "")"
            //          Text(venue)
            Text("Venuesefsfasdfa")
              .font(.system(size: 50))
            Rectangle()
              .foregroundStyle(.black)
              .frame(height: 1)
            //          Text(vm.getFormattedDateFromString(date: setlist?.eventDate ?? "", format: "MMM dd, yyyy") ?? "")
            Text("Nov 29, 2023")
              .font(.system(size: 50))
              .padding(.bottom)
          }
          .padding(.horizontal, 28)
        }
        dotLine
        ZStack {
          Rectangle()
            .cornerRadius(20)
            .foregroundStyle(.white)
            .frame(width: 1080, height: 1164)
          VStack(alignment: .leading) {
            if songCount <= 36 {
              VStack(alignment: .center) {
                ForEach(0..<songCount, id: \.self) { index in
                  Text("\(songList[index].0)")
                }
              }
            } else {
              HStack(alignment: .top) {
                VStack(alignment: .leading) {
                  ForEach(0..<36, id: \.self) { index in
                    Text("\(songList[index].0)")
                      .font(.system(size: 25))
                  }
                }
                Spacer()
                VStack(alignment: .leading) {
                  ForEach(36..<songCount, id: \.self) { index in
                    Text("\(songList[index].0)")
                      .font(.system(size: 25))
                  }
                }
              }
              .padding(.horizontal, 28)
            }
          }
          .padding(.horizontal)
        }
        dotLine
        ZStack {
          Rectangle()
            .cornerRadius(20)
            .foregroundStyle(.white)
            .frame(width: 1080, height: 162)
          HStack {
            Image("seta", bundle: Bundle(identifier: "com.creative8.seta.UI"))
              .padding(.vertical, 27)
            Spacer()
          }
          .padding(.horizontal, 28)
        }
      }
      .background(.black)
    }
  }
  
  private var dotLine: some View {
    Rectangle()
      .stroke(style: StrokeStyle(dash: [10]))
      .frame(height: 2)
      .foregroundStyle(Color.black)
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
    let origin = CGPoint(x: 0, y: 0)
    let size = CGSize(width: 1080, height: 1920)
    
    let window = UIWindow(frame: CGRect(origin: origin, size: size))
    let hosting = UIHostingController(rootView: self)
    //hosting.view.frame = CGRect(origin: origin, size: size)
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
  func shareSetlistToImage(_ songList: [(String, String?)], _ artist: String, _ setlist: Setlist?) -> UIImage {
    //@ObservedObject var vm: ArtistViewModel
    let songCount = songList.count // 15 ,45, 50
    let firstSectionSongs = songCount / 25 // 0, 1, 2
    let secondSectionSongs = songCount % 25 // 15, 20, 0
    let sectionCount = firstSectionSongs + (firstSectionSongs < 2 ? 1 : 0 ) // 1, 1, 2
    let captureView = ShareSetlistView( songList: songList,
                                        artist: artist,
                                        songCount: songCount)
    return captureView.setlistImage()
  }
}

#Preview {
  ShareSetlistView(songList: [("Miss Americana & the Heartbreak Prince", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("Miss Americana & the Heartbreak Prince", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ"),
                              ("ㅇㄹㄴㅁㅇㄹㄴㅁㅇㄹㅁ", "ㅁㄴㅇㄹ")]
                   , artist: "Noel Gallagher’s High Flying Birds", songCount: 44)
}
