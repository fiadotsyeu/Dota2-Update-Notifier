//
//  PatchesView.swift
//  Dota2 Update Notifier
//
//  Created by user on 15.04.2024.
//

import SwiftUI

struct PatchesView: View {
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("All patches")) {
                    ForEach(modelData.newsItems) { newsItem in
                        if newsItem.tag.contains("patch") {
                            NavigationLink(destination: NewsDetail(newsItem: newsItem)) {
                                NewsRow(newsItem: newsItem)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Patches")
        }
    }
}

#Preview {
    PatchesView()
        .environment(ModelData())
}
