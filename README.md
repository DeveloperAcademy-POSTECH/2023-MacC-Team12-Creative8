
<div align="center">

 <img width="744" alt="스크린샷 2024-03-21 오후 5 19 06" src="https://github.com/DeveloperAcademy-POSTECH/MacC-Team12-Creative8/assets/81157265/b37beae8-82fc-44a2-b323-c2f41dfb69ae">

![Generic badge](https://img.shields.io/badge/version-1.1.3-critical.svg) [![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FDeveloperAcademy-POSTECH%2FMacC-Team12-Creative8&count_bg=%23EFDA11&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

[<img width="220" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://user-images.githubusercontent.com/55099365/196023806-5eb7be0f-c7cf-4661-bb39-35a15146c33a.png">](https://apps.apple.com/kr/app/seta-%EC%84%B8%ED%83%80/id6471524204)


</div>

## ✨ Introduction

<div align="center">

<img width="839" alt="스크린샷 2024-03-21 오후 5 14 21" src="https://github.com/DeveloperAcademy-POSTECH/MacC-Team12-Creative8/assets/81157265/88a5addb-6704-4d8f-a319-1d126f13c383">

</div>


1. 클릭 한 번에 세트리스트를 플레이리스트로

   > 듣고 싶은 세트리스트를 발견했나요? Apple Music과 연동해서 세트리스트를 플레이리스트로 손쉽게 옮겨보세요!
   

2. 내가 찜한 아티스트의 공연정보는 간편하게

   > 여러분이 좋아하는 아티스트의 지난 공연 정보 및 다가오는 공연 정보까지도 간편하게 만나보세요.


3. 다른 아티스트의 공연정보가 궁금하다면?

   > 아티스트 검색 기능을 통해 세트리스트를 자유롭게 탐험해보세요.


4. 다시 듣고 싶은 세트리스트가 있을 땐

   > 마음에 드는 세트리스트를 발견했다면 보관함 기능을 통해 언제든지 다시 꺼내 보세요.
   
<br/>

## 🛠 Development Environment

<img width="77" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://img.shields.io/badge/iOS-17.0+-silver"> <img width="83" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://img.shields.io/badge/Xcode-15.0-blue">

### :sparkles: Skills & Tech Stack
* SwiftUI
* Tuist
* MVVM Architecture
* Combine
* URLSession
* MusicKit
* REST API
  
### 🔀 Git branch & [Git Flow]
- `feature` : 새로운 기능
- `fix` : 기능 수정 (정책에 의한 수정, 인터페이스 변경)
    - ex) 이미 만들어놨는데 디자인팀에서 바꿔야 한다고 요청이 왔을때
- `bugfix`: 버그 수정
    - 보라색 버그
- `refactor` : 리팩토링
- `docs` : 문서 작성 및 수정 (설명 주석 추가 등)
- `chore` : 기타 변경 사항 (git, .github, gradle task 등의 수정)
- `style` : 코드 포맷팅
- `design` : UI 디자인 변경

<br/>

## 🧑‍💻 Contributors

<div align="center"> 
  
| [고혜지(Hazzy)](https://github.com/Ko-HyeJi) | [김나윤(Nayla)](https://github.com/nylakim) | [김예슬(Suri)](https://github.com/suri0000) | [유인호(Musk)](https://github.com/Oreo-Mcflurry) | [이예은(Yelson)](https://github.com/Yeeunlee34) | [장수민(Lorenzo)](https://github.com/sumintnals) | [정제명(Green)](https://github.com/JJemyeong) | [최효원(Wonni)](https://github.com/wonniiii) |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|<img width="100" alt="Hazzy" src="https://avatars.githubusercontent.com/u/88470545?v=4">|<img width="100" alt="Nayla" src="https://avatars.githubusercontent.com/u/128906664?v=4">|<img width="100" alt="Suri" src="https://avatars.githubusercontent.com/u/129073316?v=4">|<img width="100" alt="Musk" src="https://avatars.githubusercontent.com/u/96654328?v=4">|<img width="100" alt="Yelson" src="https://avatars.githubusercontent.com/u/129073316?v=4">|<img width="100" alt="Lorenzo" src="https://avatars.githubusercontent.com/u/127755029?v=4">|<img width="100" alt="Green" src="https://avatars.githubusercontent.com/u/130547132?v=4)">|<img width="100" alt="Wonni" src="https://avatars.githubusercontent.com/u/81157265?v=4">|


</div>
<br/>

## 🗂️ Folder Architecture
<pre>
<code>
📦Projects
 ┣ 📂App
 ┃ ┣ 📂Resources
 ┃ ┣ 📂Sources
 ┃ ┣ 📂Support
 ┣ 📂Core
 ┃ ┣ 📂Sources
 ┃ ┃ ┣ 📂Model
 ┃ ┃ ┃ ┣ 📂ArchivedConcertInfo
 ┃ ┃ ┃ ┣ 📂ArtistInfoModel
 ┃ ┃ ┃ ┣ 📂LikeArtist
 ┃ ┃ ┃ ┣ 📂SearchHistory
 ┃ ┃ ┗ 📂Service
 ┃ ┃ ┃ ┣ 📂SearchHistoryDataManager
 ┃ ┃ ┃ ┣ 📂SwiftDataManager
 ┣ 📂Feature
 ┃ ┣ 📂Scenes
 ┃ ┃ ┣ 📂ArchiveScene
 ┃ ┃ ┃ ┣ 📂Component
 ┃ ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┣ 📂ArtistScene
 ┃ ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┣ 📂MainScene
 ┃ ┃ ┃ ┣ 📂Component
 ┃ ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┣ 📂OnboardingScene
 ┃ ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┣ 📂SearchScene
 ┃ ┃ ┃ ┣ 📂Component
 ┃ ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┣ 📂SetlistScene
 ┃ ┃ ┃ ┣ 📂Component
 ┃ ┃ ┃ ┃ ┣ 📂CaptureSetlist
 ┃ ┃ ┃ ┣ 📂View
 ┃ ┃ ┃ ┗ 📂ViewModel
 ┃ ┃ ┣ 📂SettingScene
 ┃ ┃ ┃ ┗ 📂View
 ┣ 📂UI
 ┃ ┣ 📂Resources
 ┃ ┃ ┣ 📂Colors.xcassets
 ┃ ┣ 📂Sources
 ┗ ┗ ┗ 📂Extensions
</code>
</pre>
<br/>

## :lock_with_ink_pen: License

[MIT](https://choosealicense.com/licenses/mit/)

