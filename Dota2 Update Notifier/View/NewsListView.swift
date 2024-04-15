//
//  NewsList.swift
//  Dota2 Update Notifier
//
//  Created by user on 13.04.2024.
//

import SwiftUI

struct NewsListView: View {
    @Environment(ModelData.self) var modelData
    @State private var showInternationalOnly = false
    
    var filteredNewsItems: [NewsItem] {
        modelData.newsItems.filter { newsItem in
            (!showInternationalOnly || newsItem.tag.contains("international"))
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("All news and patches")) {
                    Toggle(isOn: $showInternationalOnly) {
                        Text("The International only")
                    }
                    ForEach(filteredNewsItems) { newsItem in
                        NavigationLink(destination: NewsDetail(newsItem: newsItem)) {
                            NewsRow(newsItem: newsItem)
                        }
                    }
                }
            }
            .animation(.default, value: filteredNewsItems)
            .navigationTitle("Dota Updates Notifier")
        }
    }
}

#Preview {
    NewsListView()
        .environment(ModelData())
}
