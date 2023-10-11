//
//  UISearchbarCustom.swift
//  Feature
//
//  Created by A_Mcflurry on 10/8/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool

    init(text: Binding<String>, isEditing: Binding<Bool>) {
        self._text = text
        self._isEditing = isEditing
    }

    var body: some View {
        HStack {
            TextField("공연, 아티스트를 검색하세요", text: $text)
                .padding(7.5)
                .padding(.horizontal, 20)
                .background(Color(.systemGray6))
                .cornerRadius(7.5)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 7.5)

                        if isEditing && text.count != 0 {
                            Button {
                                self.text = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 7.5)
                            }
                        }
                    }
                )

                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                    }
                }

            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                        self.text = ""
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("취소")
                    .foregroundStyle(.black)
                }
                .padding(.horizontal, 10)
                .animation(.linear(duration: 0.25))
            }
        }
        .textCase(.none)
    }
}
