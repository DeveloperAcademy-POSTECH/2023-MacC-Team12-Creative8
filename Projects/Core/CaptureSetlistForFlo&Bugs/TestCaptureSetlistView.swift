//
//  TestCaptureSetlistView.swift
//  Core
//
//  Created by A_Mcflurry on 10/16/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//
import SwiftUI

struct TestCaptureSetlistView: View {
  let song: [String] = [
    "일과 이분의 일",
    "Love Lee",
    "후라이의 꿈",
    "WE GO",
    "Airplain Mode",
    "사랑 없는 노래",
    "항성 통신",
    "Back in Time",
    "뭐라할까!",
    "이 밤이 지나면",
    "일과 이분의 일",
    "Love Lee",
    "후라이의 꿈",
    "WE GO",
    "Airplain Mode",
    "사랑 없는 노래",
    "항성 통신",
    "Back in Time",
    "뭐라할까!",
    "이 밤이 지나면",
    "일과 이분의 일",
    "Love Lee",
    "후라이의 꿈",
    "WE GO",
    "Airplain Mode",
    "사랑 없는 노래",
    "항성 통신",
    "Back in Time",
    "뭐라할까!",
    "이 밤이 지나면",
    "일과 이분의 일",
    "Love Lee",
    "후라이의 꿈",
    "WE GO",
    "Airplain Mode",
    "사랑 없는 노래",
    "항성 통신",
    "Back in Time",
    "뭐라할까!"
  ]

  let artist: [String] = [
    "투투",
    "악동뮤지션",
    "AKMU",
    "프로미스나인",
    "Fromis_9",
    "이구이",
    "너드 커넥션",
    "Nead Connection",
    "브리즈",
    "임재범",
    "투투",
    "악동뮤지션",
    "AKMU",
    "프로미스나인",
    "Fromis_9",
    "이구이",
    "너드 커넥션",
    "Nead Connection",
    "브리즈",
    "임재범",
    "투투",
    "악동뮤지션",
    "AKMU",
    "프로미스나인",
    "Fromis_9",
    "이구이",
    "너드 커넥션",
    "Nead Connection",
    "브리즈",
    "임재범",
    "투투",
    "악동뮤지션",
    "AKMU",
    "프로미스나인",
    "Fromis_9",
    "이구이",
    "너드 커넥션",
    "Nead Connection",
    "브리즈"
  ]
  var body: some View {
    VStack {
      Button("Take Screen") {
        takeSetlistToImage(song, artist)
      }
    }
  }
}

#Preview {
  TestCaptureSetlistView()
}
