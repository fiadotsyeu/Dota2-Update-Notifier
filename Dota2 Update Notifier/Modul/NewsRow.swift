//
//  NewsRow.swift
//  Dota2 Update Notifier
//
//  Created by user on 12.04.2024.
//

import SwiftUI


struct NewsRow: View {
    var newsItem: NewsItem
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack() {
                
                Text(newsItem.title)
                    .font(.system(size: 23))
                Spacer()
                
            }
            HStack {
                if newsItem.isFavorite {
                    Image("Heart.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .colorMultiply(.red)
                } else {
                    Image("Heart")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .colorMultiply(.gray)
                }
                Spacer()
                Text(newsItem.date)

                
            }
            
        }
    }
}

#Preview {
    let newsItems = ModelData().newsItems
    return Group {
        NewsRow(newsItem: newsItems[0])
        NewsRow(newsItem: newsItems[1])
    }
}
