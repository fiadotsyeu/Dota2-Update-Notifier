//
//  NewsList.swift
//  Dota2 Update Notifier
//
//  Created by user on 13.04.2024.
//

import SwiftUI

struct NewsListView: View {
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        NavigationView {
            List(modelData.newsItems) { newsItem in
                NavigationLink(destination: NewsDetail(newsItem: newsItem)) {
                    NewsRow(newsItem: newsItem)
                }
            }
            .navigationTitle("Dota Updates Notifer")
        }
    }
}

#Preview {
    NewsListView()
        .environment(ModelData())
}
