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
    let rssURL = URL(string: "https://store.steampowered.com/feeds/news/app/570/&l=english&snr=1_2108_9__2107")!
        
    var filteredNewsItems: [NewsItem] {
        modelData.newsItems.filter { newsItem in
            (!showInternationalOnly || newsItem.tag.contains("international"))
        }
    }
        
    var body: some View {
        let _rssParser = RSSParser(modelData: modelData)
        
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
