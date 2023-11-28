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
  @ObservedObject var vm = SetlistViewModel()
  let songList: [(String, String?)]
  let artist: String
  let setlist: Setlist?
  let headHeight: CGFloat
  let fontSize: CGFloat
  let aLineMax: Int
  let is2Columns: Bool

  init(songList: [(String, String?)], artist: String, setlist: Setlist?) {
    self.songList = songList
    self.artist = artist
    self.setlist = setlist

    let totalLine = songList.count + ((setlist?.sets?.setsSet ?? []).count-1) * 2
    headHeight = setlist?.tour?.name == nil ? 530 : 600
    aLineMax = totalLine > 50 ? 36 : 25
    is2Columns = totalLine > 36 ? true : false
    switch totalLine {
    case 0...18: fontSize = 50
    case 19...20: fontSize = 45
    case 21...36: fontSize = 30
    default: fontSize = 25
    }
  }

  var body: some View {
    VStack(spacing: -3) {
      headView
      dotLine
      shareListView
      dotLine
      bottomView
    }
    .kerning(1.1)
    .frame(width: 1080, height: 1920)
    .background(Color.mainBlack)
  }

  private var dotLine: some View {
    Rectangle()
      .stroke(style: StrokeStyle(lineWidth: 6, dash: [12]))
      .frame(height: 4)
      .foregroundStyle(Color.black)
      .alignmentGuide(.top) { _ in 1 }
      .padding(.horizontal, 40)
  }

  private var whiteBox: some View {
    RoundedRectangle(cornerRadius: 40)
      .foregroundStyle(.white)
    
  }

  private var dividerLine: some View {
    Rectangle()
      .foregroundStyle(.black)
      .frame(height: 3)
      .padding(.vertical, -10)
  }

  private var headView: some View {
    ZStack {
      whiteBox
      VStack(alignment: .leading) {
        Text(artist)
          .font(.system(size: 50))
        dividerLine
        if let tour = setlist?.tour?.name {
          Text(tour)
            .font(.system(size: 50))
          dividerLine
        }
        let venue = "\(setlist?.venue?.name ?? ""), \(setlist?.venue?.city?.name ?? ""), \(setlist?.venue?.city?.country?.name ?? "")"
        Text(venue)
          .font(.system(size: 50))
        dividerLine
        Text(vm.getFormattedDateFromString(date: setlist?.eventDate ?? "", format: "MMM dd, yyyy") ?? "")
          .font(.system(size: 50))
          .padding(.bottom)
      }
      .padding([.horizontal, .bottom], 28)
      .frame(maxWidth: .infinity, maxHeight: headHeight, alignment: .bottomLeading)
    }
    .frame(width: 1080, height: headHeight)
  }

  private var bottomView: some View {
    ZStack {
      whiteBox
      Image("seta", bundle: Bundle(identifier: "com.creative8.seta.UI"))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 28)
    }
      .frame(width: 1080, height: 162)
  }

  private var shareListView: some View {
    ZStack {
      whiteBox
      
      Group {
        if !is2Columns {
          VStack {
            ForEach(setlist?.sets?.setsSet ?? [], id: \.self) { session in
              let sessionName = session.name ?? (session.encore != nil ? "Encore" : "")
              if sessionName != "" {
                Text("\n\(sessionName)")
                  .fontWeight(.semibold)
                  .underline()
                  .font(.system(size: fontSize))
                  .lineLimit(2)
              }
              if let songs = session.song {
                ForEach(0..<songs.count, id: \.self) { index in
                  Text(songList[index].0)
                    .font(.system(size: fontSize))
                    .lineLimit(1)
                }
              }
            }
          }
        } else {

        }
      }
      .frame(width: 1040)
    }
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
    var sessionInfo: [(String, Int)] = []
    if let setsSet = setlist?.sets?.setsSet {
            for session in setsSet {
              let sessionName = session.name ?? (session.encore != nil ? "Encore" : "")
              let newSession: (String, Int) = (sessionName, session.song?.count ?? 0)
              sessionInfo.append(newSession)
            }
    }
    let captureView = ShareSetlistView(songList: songList,
                                       artist: artist,
                                       setlist: setlist)
    return captureView.setlistImage()
  }
}

//


//ScrollView {
//  VStack(spacing: -1) {
//    ZStack {
//      Rectangle()
//        .cornerRadius(20)
//        .foregroundStyle(.white)
//        .frame(width: 1080, height: 589)

//      .padding(.horizontal, 28)
//    }
//    dotLine
//    ZStack {
//      Rectangle()
//        .cornerRadius(20)
//        .foregroundStyle(.white)
//        .frame(width: 1080, height: 1164)
//      VStack(alignment: .leading) {
//        if songList.count <= 36 {
//          VStack(alignment: .center) {
//            ForEach(0..<songList.count, id: \.self) { index in
//              Text("\(songList[index].0)")
//            }
//          }
//        } else {
//          HStack(alignment: .top) {
//            VStack(alignment: .leading) {
//              ForEach(0..<36, id: \.self) { index in
//                Text("\(songList[index].0)")
//                  .font(.system(size: 25))
//              }
//            }
//            Spacer()
//            VStack(alignment: .leading) {
//              ForEach(36..<songList.count, id: \.self) { index in
//                Text("\(songList[index].0)")
//                  .font(.system(size: 25))
//              }
//            }
//          }
//          .padding(.horizontal, 28)
//        }
//      }
//      .padding(.horizontal)
//    }
//    dotLine
//    ZStack {
//      Rectangle()
//        .cornerRadius(20)
//        .foregroundStyle(.white)
//        .frame(width: 1080, height: 162)
//      HStack {
//
//          .padding(.vertical, 27)
//        Spacer()
//      }
//      .padding(.horizontal, 28)
//    }
//  }
//  .background(.black)
//}
//}
