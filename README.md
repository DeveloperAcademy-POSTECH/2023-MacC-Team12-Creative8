# MacC-Team12-Creative8

# Convention

## 종류
 - `feature` : 새로운 기능
 - `fix` : 기능 수정 (정책에 의한 수정, 인터페이스 변경)
    - ex) 이미 만들어놨는데 디자인팀에서 바꿔야 한다고 요청이 왔을때
 - `bugfix`: 버그 수정
    - 보라색 버그
 - `refactor` : 리팩토링
 - `docs` : 문서 작성 및 수정 (설명 주석 추가 등)
 - `chore` : 기타 변경 사항 (git, .github, gradle task 등의 수정)
 - `style` : 코드 포맷팅

## 네이밍
*노션에 작업 등록 후 이슈 업뎃*
 - 이슈</br>
  `이슈 핵심 내용`</br>
  `MainView UI 구현`</br>

 - 브랜치</br>
  `#이슈 번호/개발할 기능 or 뷰 이름(camelCase)`</br>
  `#123/mainViewUI`</br>
  
 - 커밋</br>
  `[브랜치 종류]#이슈번호 - 작업 핵심 내용`</br>
  `[Feat]#123 - add MainView.swift`</br>
  
 - PR</br>
  `#이슈번호/커밋 내용`</br>
  `#123/메인 화면 개발`</br>

## 생성
 - 한 이슈당 브랜치 하나 1:1
      
## 삭제
 - 머지한 브랜치는 그대로 놔두기. 삭제 X

## Code Review
*2명 이상 코드리뷰 필참, 2명 Approve*
 - **P1: 꼭 반영해주세요 (Request changes)**
 - **P2: 적극적으로 고려해주세요 (Request changes)**
 - **P3: 웬만하면 반영해 주세요 (Comment)**
 - **P4: 반영해도 좋고 넘어가도 좋습니다 (Approve)**
 - **P5: 그냥 사소한 의견입니다 (Approve)**
 
