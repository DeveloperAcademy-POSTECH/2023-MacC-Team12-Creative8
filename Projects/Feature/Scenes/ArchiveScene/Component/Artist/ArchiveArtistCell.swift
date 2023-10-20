//
//  ArchiveArtistCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

struct ArchiveArtistCell: View {
  let artistUrl: URL
  let isNewUpdate: Bool
  var body: some View {
      AsyncImage(url: artistUrl) { image in
        image
          .centerCropped()
          .aspectRatio(1.0, contentMode: .fit)
          .clipShape(RoundedRectangle(cornerRadius: 20))
      } placeholder: {
        ProgressView()
      }
      .frameForCell()
  }
}

#Preview {
  ArchiveArtistCell(artistUrl: URL(string: "https://newsimg.sedaily.com/2019/10/11/1VPHATB1H9_1.jpg")!,
                    isNewUpdate: true)
}

// 이친구들은 무엇인가요?
// -> 새로 업데이트 되면 이미지에 알림을 줘야하는데, 그린과 이야기 해서 일단 다음 업데이트때 하기로 하였습니다.
// 그래서 일단 코드를 보존해놓았습니다.

//  .overlay {
//    if isNewUpdate {
//      Circle()
//        .foregroundStyle(.blue)
//        .frame(width: size/4.6)
//        .padding(3)
//        .background {
//          Circle()
//            .foregroundStyle(.white)
//        }
//        .offset(getOffset(radius: size/2))
//    }
//  }

// https://www.youtube.com/watch?v=bTs0DcMxDT8
// func getOffset(radius: Double) -> CGSize {
//  let angleInRadians = Angle(degrees: -40).radians
//  let xPosition = radius * cos(angleInRadians)
//  let yPosition = radius * sin(angleInRadians)
//  return CGSize(width: xPosition, height: yPosition)
// }
