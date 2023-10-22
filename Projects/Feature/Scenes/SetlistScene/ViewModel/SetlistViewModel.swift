//
//  SetlistViewModel.swift
//  Feature
//
//  Created by 고혜지 on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

final class SetlistViewModel: ObservableObject {
  @Published var isBookmarked: Bool = false
  @Published var isEmptySetlist: Bool = false
}
