//
//  ContentView.swift
//  Dota2 Update Notifier
//
//  Created by user on 09.04.2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(ModelData.self) var modelData
    let rssURL = URL(string: "https://store.steampowered.com/feeds/news/app/570/?cc=CZ&l=english&snr=1_2108_9__2107")!
    
    var body: some View {
        let rssParser = RSSParser(modelData: modelData)
        
        NavBarView()
            .onAppear {
                rssParser.parseRSS(from: rssURL)
            }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
