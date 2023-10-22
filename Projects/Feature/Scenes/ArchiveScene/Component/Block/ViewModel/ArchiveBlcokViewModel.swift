//
//  ArchiveBlcokViewModel.swift
//  Feature
//
//  Created by A_Mcflurry on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

final class ArchiveBlcokViewModel: ObservableObject {
    @Published var concertCellInfo: [(Int, Int)] = []
    @Published var maxminCnt: (Int, Int) = (0, 0)
    @Published var selecteYear: Int = 0
}
