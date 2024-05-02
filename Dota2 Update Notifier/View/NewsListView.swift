//
//  NewsList.swift
//  Dota2 Update Notifier
//
//  Created by user on 13.04.2024.
//

import SwiftUI

struct NewsListView: View {
    @Environment(ModelData.self) var modelData
    @AppStorage("selectedOptionFilter") private var selectedOptionFilter = 0
    @AppStorage("language") private var selectedOptionlanguage = "en"
        
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
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
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
        var rssURLs = updateContentForAppLanguage(language: selectedOptionlanguage)
        
        NavigationView {
            List {
                Section(header: Text(LocalizedStringKey("All news and patches"))) {
                    Picker(selection: $selectedOptionFilter, label: Text(LocalizedStringKey("Select a filter"))) {
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
            .onAppear {
                rssURLs.forEach { url in
                    Task {
                        await rssParser.parseRSS(from: url)
                    }
                }
            }
            .animation(.default, value: selectedOptionFilter)
            .navigationTitle("Dota Updates Notifier")
            .refreshable {
                rssURLs.forEach { url in
                    Task {
                        await rssParser.parseRSS(from: url)
                    }
                }
            }
        }
    }
}

#Preview {
    NewsListView()
        .environment(ModelData())
}
