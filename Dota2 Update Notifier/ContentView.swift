//
//  ContentView.swift
//  Dota2 Update Notifier
//
//  Created by user on 09.04.2024.
//

import SwiftUI
import UserNotifications

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
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Permission approved!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
