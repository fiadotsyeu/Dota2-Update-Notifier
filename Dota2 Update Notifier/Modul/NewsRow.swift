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
                    Image("Heart_fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .colorMultiply(Color("Color_heart_fill"))
                } else {
                    Image("Heart")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .colorMultiply(Color("Color_heart"))
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
    }
}
