//
//  NewsList.swift
//  Dota2 Update Notifier
//
//  Created by user on 13.04.2024.
//

import SwiftUI

struct NewsListView: View {
    @Environment(ModelData.self) var modelData
    @State private var selectedOptionFilter = 0
    
    let rssURL = URL(string: "https://store.steampowered.com/feeds/news/app/570/&l=english&snr=1_2108_9__2107")!
        
    func applyFilter(filteredBy: Int) -> [NewsItem] {
        switch filteredBy {
        case 0:
            return modelData.newsItems // Returning all news without filtering
        case 1:
            return modelData.newsItems.filter { $0.tag.contains("News") }
        case 2:
            return modelData.newsItems.filter { $0.tag.contains("Patch") }
        default:
            return modelData.newsItems.filter { $0.tag.contains("The International") }
        }
    }


    var body: some View {
        let _rssParser = RSSParser(modelData: modelData)
        
        NavigationView {
            List {
                Section(header: Text("All news and patches")) {
                    Picker(selection: $selectedOptionFilter, label: Text("Select a filter")) {
                        Text("All").tag(0)
                        Text("News").tag(1)
                        Text("Patches").tag(2)
                        Text("The International").tag(3)
                    }
                    .pickerStyle(DefaultPickerStyle())
                    
                    ForEach(applyFilter(filteredBy: selectedOptionFilter)) { newsItem in
                        NavigationLink(destination: NewsDetail(newsItem: newsItem)) {
                            NewsRow(newsItem: newsItem)
                        }
                    }
                }
            }
            .animation(.default, value: selectedOptionFilter)
            .navigationTitle("Dota Updates Notifier")
        }
    }
}

#Preview {
    NewsListView()
        .environment(ModelData())
}
