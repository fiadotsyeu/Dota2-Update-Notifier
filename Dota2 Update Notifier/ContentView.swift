//
//  ContentView.swift
//  Dota2 Update Notifier
//
//  Created by user on 09.04.2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(ModelData.self) var modelData
    let rssURLs = [URL(string: "https://www.dotabuff.com/blog.rss"), 
                   URL(string: "https://store.steampowered.com/feeds/news/app/570/l=english")]
    
    var body: some View {
        let rssParser = RSSParser(modelData: modelData)
        
        NavBarView()
            .onAppear {
                rssURLs.forEach { url in
                    rssParser.parseRSS(from: url!)
                }
            }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
