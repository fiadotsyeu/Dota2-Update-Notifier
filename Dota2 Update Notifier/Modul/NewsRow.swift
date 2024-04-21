//
//  NewsRow.swift
//  Dota2 Update Notifier
//
//  Created by user on 12.04.2024.
//

import SwiftUI


struct NewsRow: View {
    var newsItem: NewsItem
    @State private var imageURL: URL?
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Text(newsItem.title)
                    .font(.system(size: 23))
                Spacer()
            }
            HStack {
                if newsItem.isFavorite {
                    Image("Favorites.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .colorMultiply(.red)
                } else {
                    Image("Favorites")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .colorMultiply(.gray)
                }
                Spacer()
                Text(newsItem.date)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Group {
                if let imageURL = imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            Color.gray // Placeholder color
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .opacity(0.1)
                        case .failure:
                            Color.red // Error color
                        @unknown default:
                            Color.gray // Placeholder color
                        }
                    }
                    .scaledToFill()
                } else {
                    Image("d2HeaderItem") // Default background image if imageURL is nil
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .opacity(0.1)
                }
            }
        )
        .frame(height: 100)
        .onAppear {
            if let imageURL = newsItem.imageURL {
                self.imageURL = imageURL
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
