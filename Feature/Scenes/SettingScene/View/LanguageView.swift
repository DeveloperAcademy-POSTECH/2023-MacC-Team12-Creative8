//
//  FAQView.swift
//  Feature
//
//  Created by 예슬 on 2023/11/15.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct LanguageView: View {
  
  @State private var language = "한국어"
  
  let languages = ["한국어", "English"]
  
  var body: some View {
    VStack(alignment: .leading) {
      Button {
        
      } label: {
        Text("한국어")
      }
      
      Divider()
        .foregroundStyle(Color.lineGrey1)
      
      Button {
        
      } label: {
        Text("English")
      }
    }
    .padding(24)
  }
}

//func setLanguage() {
//
//  // 설정된 언어 코드 가져오기
//  let language = UserDefaults.standard.array(forKey: "AppleLanguages")?.first as! String // 초기에 "ko-KR" , "en-KR" 등으로 저장되어있음
//  let index = language.index(language.startIndex, offsetBy: 2)
//  let languageCode = String(language[..<index]) // "ko" , "en" 등
//  
//  // 설정된 언어 파일 가져오기
//  let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
//  let bundle = Bundle(path: path!)
//  
//}
//
//@IBAction func koreanClicked(_ sender: UIButton) {
//    //한국어로 변경
//    UserDefaults.standard.set(["ko"], forKey: "AppleLanguages")
//    UserDefaults.standard.synchronize()
//    
//    //보통 메인화면으로 이동시켜줌
//    setLanguage()
//}
//@IBAction func englishClicked(_ sender: UIButton) {
//    //영어로 변경
//    UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
//    UserDefaults.standard.synchronize()
//    
//    //보통 메인화면으로 이동시켜줌
//    setLanguage()
//}


//@IBAction func onClickKorean(_ sender: Any) {
//        UserDefaults.standard.setValue("ko", forKey: "languageType")
//        Localize.setCurrentLanguage("ko")
//
//        setUI()
//
//    }
//    @IBAction func onClickEnglish(_ sender: Any) {
//        UserDefaults.standard.setValue("en", forKey: "languageType")
//        Localize.setCurrentLanguage("en")
//        setUI()
//    }
//
//private func setUI(){
//        let languageType = UserDefaults.standard.string(forKey: "languageType") ?? "ko"
//        setButtonUI(languageType:languageType)
//    }

  
  #Preview {
    LanguageView()
  }
