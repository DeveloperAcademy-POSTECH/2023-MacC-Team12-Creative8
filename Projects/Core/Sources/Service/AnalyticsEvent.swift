//
//  AnalyticsEvent.swift
//  Core
//
//  Created by 예슬 on 2/22/25.
//  Copyright © 2025 com.creative8.seta. All rights reserved.
//

import Foundation
import FirebaseAnalytics

public struct AnalyticsEvent {
  private init() {}
  
  public struct Screen {
    private init() {}
    
    public static let onboarding = "V1_onboarding_default"
    public static let main = "V2_main_default"
    public static let mainToolTip = "V2_1_main_default_tooltip"
    public static let artist = "V3_artist_default"
    public static let artistArchivedList = "V3_artist_archived_list"
    public static let archive = "V4_archive_default"
    public static let search = "V5_search_default"
    public static let setlist = "V6_setlist_default"
    public static let share = "V6_1_share_default"
    public static let more = "V7_more_default"
  }
  
  public struct Event {
    private init() {}
    
    // 온보딩
    public static let onboardingGenre = "B1_1_onboarding_genre"
    public static let onboardingSelected = "B1_2_onboarding_selected" // 아티스트 1명 선택
    public static let onboardingSelectedTwo = "B1_2_1_onboarding_selected_two"
    public static let onboardingSelectedThree = "B1_2_2_onboarding_selected_three"
    public static let onboardingSelectedFour = "B1_2_3_onboarding_selected_four"
    public static let onboardingSelectedAll = "B1_2_4_onboarding_selected_all"  // 아티스트 5명 선택
    public static let onboardingToastUnselected = "T1_1_onboarding_toast_unselected"  // 아티스트 1명도 선택 안 하고 버튼 누를 경우
    public static let onboardingToastDone = "T1_2_onboarding_toast_done"  // 아티스트 6명 이상 누를 경우
    
    // 메인
    public static let mainSetlistToggle = "B2_1_main_setlist_toggle"  // 세트리스트 전체 보기 버튼
    public static let mainNoSetlistInformation = "B2_2_main_nosetlist_information"  // 포함된 곡이 없어요 인포메이션 버튼
    public static let mainLikedArtist = "B2_3_main_liked_artist"  // 찜한 아티스트 버튼
    
    // 아티스트
    public static let artistArchivedListScroll = "S3_artist_archived_list_scroll" // 보관한 공연 스크롤 하는지
    public static let artistSeeArchivedList = "B3_artist_see_archived_list" // 보관함에서 보기 버튼
    
    // 보관함
    public static let archiveListAll = "B4_1_archive_list_all"  // 아티스트 선택 전체 버튼
    public static let archiveListArtist = "B4_2_archive_list_artist"  // 아티스트 이름 버튼
    public static let archiveListMenu = "B4_3_archive_list_menu"  // 보관한 세트리스트의 메뉴 버튼(... 버튼)
    public static let archivedSetlist = "B4_4_archived_setlist"  // 보관한 세트리스트 누르기
    
    // 검색
    public static let searchBar = "B5_1_search_bar"
    public static let searchDomesticArtist = "B5_2_domestic_artist"
    public static let searchOverseasArtist = "B5_3_overseas_artist"
    
    // 세트리스트(토스트 메시지)
    public static let setlistToastSaved = "T6_1_setlist_toast_saved"  // 보관함-북마크한 공연에 담겼어요
    public static let setlistToastCanceled = "T6_2_setlist_toast_canceled"  // 보관이 취소되었어요!
    public static let setlistToastPlaylistBugs = "T6_3_setlist_toast_playlist_bugs" // 캡쳐된 이미지를 앨범에서 확인하세요
    public static let setlistToastPlaylistAppleMusic = "T6_4_setlist_toast_playlist_apple_music"  // Apple Music로 세트리스트가 옮겨지고 있어요!
    public static let setlistToastPlaylistNoneAppleMusic = "T6_4_1_setlist_toast_playlist_none_apple_music" // 기능을 사용하려면 Apple Music 앱이 필요해요
    public static let setlistToastPlaylistSpotify = "T6_5_setlist_toast_playlist_spotify" // Spotify로 세트리스트가 옮겨지고 있어요!
    public static let setlistToastPlaylistNoneSpotify = "T6_5_1_setlist_toast_playlist_none_spotify"  // 기능을 사용하려면 Spotify 앱이 필요해요
    public static let setlistScroll = "S6_setlist_scroll" // 세트리스트 스크롤 하는지
    
    // 세트리스트(버튼)
    public static let setlistMakePlaylist = "B6_1_setlist_make_playlist"
    public static let setlistAppleMusic = "B6_1_1_setlist_apple_music"
    public static let setlistSpotify = "B6_1_2_setlist_spotify"
    public static let setlistBugs = "B6_1_3_setlist_bugs"
    public static let setlistShare = "B6_2_setlist_share"
    public static let setlistArchive = "B6_3_setlist_archive"
    
    // 공유하기
    public static let shareInstagramStory = "B6_2_1_share_instagram_story"
    public static let shareSaveImage = "B6_2_2_share_save_image"
    public static let shareMoreOption = "B6_2_3_share_more_option"
    public static let shareToastSaveImage = "T6_1_1_share_toast_save_image"
    
    // 더보기
    public static let moreSetlistFM = "B7_more_setlist_fm"  // Setlist.fm 바로가기 버튼
  }
  
  public static func trackScreen(screenName: String, screenClass: String) {
    Analytics.logEvent(AnalyticsEventScreenView,
                       parameters: [AnalyticsParameterScreenName: screenName,
                                    AnalyticsParameterScreenClass: screenClass])
  }
  
  public static func trackButtonTap(buttonName: String) {
    Analytics.logEvent(buttonName, parameters: nil)
  }
  
  public static func trackToastMessage(message: String) {
    Analytics.logEvent(message, parameters: nil)
  }
}
