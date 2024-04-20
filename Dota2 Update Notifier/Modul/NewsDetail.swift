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
    
    var newsItemIndex: Int? {
        if newsItem == newsItem {
            return modelData.newsItems.firstIndex(where: { $0.id == newsItem.id })
        } else {
            return nil
        }
    }

    
    var body: some View {
        @Bindable var modelData = modelData
        
        ScrollView {
            GeometryReader { geometry in
                Image("d2HeaderItem")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(newsItem.title)
                        .font(.title)
                        .bold()
                    Spacer()
                    FavoriteButton(isSet: $modelData.newsItems[newsItemIndex!].isFavorite)
                }
                
                HStack {
                    Text("URL: ")
                        .bold()
                    if let url = newsItem.url {
                        Link("Go to the link", destination: url)
                    } else {
                        // Обработка случая, когда url равен nil
                        Text("No link available")
                    }
                    Spacer()
                    Text("Date:")
                        .bold()
                    Text(newsItem.date)
                        .font(.subheadline)
                }
                
                Divider()
                
                
                Spacer()
                Text(newsItem.content)
                Spacer()
            }
            .padding(.top, 140)
            
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
