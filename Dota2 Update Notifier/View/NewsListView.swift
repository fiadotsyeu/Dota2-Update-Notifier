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
    
    let rssURLs = [URL(string: "https://www.dotabuff.com/blog.rss"),
                   URL(string: "https://store.steampowered.com/feeds/news/app/570/l=english")]
        
    func applyFilter(filteredBy: Int) -> [NewsItem] {
        var sortedItems: [NewsItem]
        
        switch filteredBy {
        case 0:
            sortedItems = modelData.newsItems // Returning all news without filtering
        case 1:
            sortedItems = modelData.newsItems.filter { $0.tag.contains("News") }
        case 2:
            sortedItems = modelData.newsItems.filter { $0.tag.contains("Patch") }
        case 3:
            sortedItems = modelData.newsItems.filter { $0.tag.contains("Update") }
        default:
            sortedItems = modelData.newsItems.filter { $0.tag.contains("The International") }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy, HH:mm"
        
        sortedItems.sort { (item1, item2) -> Bool in
            if let date1 = dateFormatter.date(from: item1.date), let date2 = dateFormatter.date(from: item2.date) {
                return date1 > date2
            } else {
                return false // Handle invalid dates if necessary
            }
        }
        return sortedItems
    }


    var body: some View {
        let rssParser = RSSParser(modelData: modelData)
        
        NavigationView {
            List {
                Section(header: Text("All news and patches")) {
                    Picker(selection: $selectedOptionFilter, label: Text("Select a filter")) {
                        Text("All").tag(0)
                        Text("News").tag(1)
                        Text("Patches").tag(2)
                        Text("Updates").tag(3)
                        Text("The International").tag(4)
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
            .refreshable {
                rssURLs.forEach { url in
                    rssParser.parseRSS(from: url!)
                }
            }
        }
    }
}

#Preview {
    NewsListView()
        .environment(ModelData())
}
