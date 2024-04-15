//
//  FavoritsView.swift
//  Dota2 Update Notifier
//
//  Created by user on 14.04.2024.
//

import SwiftUI

struct FavoritsView: View {
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Favorite patches and news")) {
                    ForEach(modelData.newsItems) { newsItem in
                        if newsItem.isFavorite {
                            NavigationLink(destination: NewsDetail(newsItem: newsItem)) {
                                NewsRow(newsItem: newsItem)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritsView()
        .environment(ModelData())
}
