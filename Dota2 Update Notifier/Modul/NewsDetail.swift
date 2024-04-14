//
//  NewsDetail.swift
//  Dota2 Update Notifier
//
//  Created by user on 13.04.2024.
//

import SwiftUI

struct NewsDetail: View {
    @Environment(ModelData.self) var modelData
    var newsItem: NewsItem
    
    var newsItemIndex: Int {
        modelData.newsItems.firstIndex(where: { $0.id == newsItem.id })!
    }
    
    var body: some View {
        @Bindable var modelData = modelData
        
        ScrollView {
            Image("2151181021")
                .resizable()
                .frame(width: .infinity, height: 100)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(newsItem.title)
                        .font(.title)
                        .bold()
                    Spacer()
                    FavoriteButton(isSet: $modelData.newsItems[newsItemIndex].isFavorite)
                        .padding(.bottom)
                }
                
                HStack {
                    Text("URL: ")
                        .bold()
                    Link("Go to the link", destination: newsItem.url)
                    Spacer()
                    Text("Date:")
                        .bold()
                    Text(newsItem.date)
                        .font(.subheadline)
                }
                
                Divider()
                
                Text(newsItem.leadIn)
                    .font(.system(size: 25))
                Spacer()
                Text(newsItem.content)
                Spacer()
            }
            .padding(.top, 50)
            
        }
        .padding()
        .navigationTitle(newsItem.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    let modelData = ModelData()
    return NewsDetail(newsItem: modelData.newsItems[0])
        .environment(modelData)
}
