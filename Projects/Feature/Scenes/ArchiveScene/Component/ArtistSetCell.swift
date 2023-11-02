//
//  ArtistSetCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/31/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI

struct ArtistSetCell: View {
	let name: String
	let isSelected: Bool
	var body: some View {
		Text(name)
			.foregroundStyle(isSelected ? Color.fontWhite : Color.fontBlack)
			.padding()
			.background {
				let color = isSelected ? Color.fontBlack : Color.mainGrey1
				color.clipShape(RoundedRectangle(cornerRadius: 12))
			}
	}
}

#Preview {
	ArtistSetCell(name: "방탄소년단", isSelected: false)
}
