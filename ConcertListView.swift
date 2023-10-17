//
//  ConcertLIstView.swift
//  Feature
//
//  Created by 장수민 on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData

struct ConcertListView: View {
    @State var dataManager = DataManager()
    @State var currentShowingConcerts = DataManager().concerts
    @Environment(\.modelContext) var modelContext
    
    static let dateformat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 M월 d일"
        return formatter
    }()
    var body: some View {
        VStack {
            if dataManager.isConcertsEmpty() {
                VStack(spacing: 0) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 40))
                        .padding(.bottom, 28)
                    Text("찜한 공연이 없어요")
                        .font(.callout)
                        .bold()
                        .padding(.bottom, 9)
                    Text("내가 좋아하는 아티스트의 공연을 찜하고\n세트리스트를 확인해보세요 ")
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .opacity(0.8)
                }
                .onAppear {
                    dataManager.context = modelContext
                    dataManager.fetchConcerts()
                }
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(dataManager.concertYears, id: \.self) { year in
                                    Button(action: {
                                        if let selectedYear = Int(year) {
                                            if dataManager.selectedYear == selectedYear {
                                                // 전체 연도의 공연 목록을 표시하도록 처리
                                                dataManager.selectedYear = 0 // 선택된 연도를 초기화
                                                currentShowingConcerts = dataManager.concerts // 전체 공연 목록을 표시
                                            } else {
                                                // 선택된 연도가 있는 경우 해당 연도의 공연 목록을 표시
                                                dataManager.selectedYear = selectedYear
                                                let filteredConcerts = dataManager.filterConcerts(byYear: selectedYear)
                                                currentShowingConcerts = filteredConcerts
                                            }
                                        } else {
                                            // 선택된 연도가 없을 때의 처리
                                            currentShowingConcerts = dataManager.concerts
                                        }
                                        dataManager.fetchConcerts()
                                    }) {
                                        Text(year)
                                    }
                                    .buttonStyle(YearButton())
                                }
                            }
                        }
                        .safeAreaPadding(.horizontal, 20)
                        .padding(.bottom, 24)
                        LazyVStack(spacing: 0) {
                            ForEach(currentShowingConcerts) { item in
                                ListView(item: item, dataManager: dataManager)
                            }
                        }
                    }
                }
                .onAppear {
                    dataManager.context = modelContext
                    dataManager.separateConcertsByYear()
                    currentShowingConcerts = dataManager.concerts
                }
            }
        }
    }
    
    struct ListView: View {
        @State var item: ArchivedConcertInfo
        @ObservedObject var dataManager: DataManager
        
        var body: some View {
            VStack(spacing: 0) {
                HStack {
                    Text(item.eventDate, formatter: ConcertListView.dateformat)
                        .font(.caption)
                        .bold()
                    Spacer()
                    Text(item.venue)
                        .font(.caption)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.bottom, 8)
                HStack(alignment: .bottom) {
                    VStack(alignment: . leading) {
                        Text(item.artist)
                            .fontWeight(.semibold)
                        Text(item.tour)
                            .font(.system(size: 14))
                    }
                    Spacer()
                    VStack {
                        Button {
                            dataManager.deleteItem(item: item)
                            dataManager.separateConcertsByYear()
                            dataManager.fetchConcerts()
                        } label: {   Image(systemName: "bookmark.fill")
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 14, bottom: 12, trailing: 14))
            .background(RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.gray))
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
    }
    struct YearButton: ButtonStyle {
        let scaledAmount: CGFloat
        
        init(scaledAmount: CGFloat = 0.99) {
            self.scaledAmount = scaledAmount
        }
        func makeBody(configuration: Configuration) -> some View{
            configuration.label       .padding(EdgeInsets(top: 12, leading: 17, bottom: 12, trailing: 17))
                .background(RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.gray))
                .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
                .brightness(configuration.isPressed ? 0.05 : 0)
                .opacity(configuration.isPressed ? 0.9 : 1.0)
        }
    }
}

#Preview {
    ConcertListView()
}
