//
//  NewsDetail.swift
//  Dota2 Update Notifier
//
//  Created by user on 13.04.2024.
//

import SwiftUI
import WebKit

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
        
        VStack(alignment: .leading) {
            HStack {
                Text(newsItem.title)
                    .font(.title)
                    .bold()
                Spacer()
                if let newsItemIndex = newsItemIndex {
                    FavoriteButton(isSet: $modelData.newsItems[newsItemIndex].isFavorite)
                } else {
                    // Обработка ситуации, когда newsItemIndex равен nil
                    Text("News item index is nil")
                }
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
            HTMLView(htmlContent: generateHTMLContent(content: newsItem.content))
                .frame(maxWidth: .infinity)
                .navigationTitle(newsItem.title)
                .navigationBarTitleDisplayMode(.inline)
            Spacer()
        }
        .padding()
    }
}



struct HTMLView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}


func generateHTMLContent(content: String) -> String {
    var htmlContent = """
    <!DOCTYPE html>
    <html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                font-size: 20px;
                margin: 10px;
            }
            img {
                max-width: 100%;
                height: auto;
            }
        </style>
    </head>
    <body>
    """
    
    htmlContent += "<p>\(content)</p>"
    htmlContent += """
    </body>
    </html>
    """
    
    return htmlContent
}


#Preview {
    let modelData = ModelData()
    return NewsDetail(newsItem: modelData.newsItems[0])
        .environment(modelData)
}
