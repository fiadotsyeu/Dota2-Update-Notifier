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
                    // Handling the situation when newsItemIndex is nil.
                    Text("News item index is nil")
                }
            }
            
            HStack {
                Text("URL: ")
                    .bold()
                if let url = newsItem.url {
                    Link("Go to the link", destination: url)
                } else {
                    // Handling the case when the URL is nil
                    Text("No link available")
                }
                Spacer()
                Text("Date:")
                    .bold()
                Text(newsItem.date)
                    .font(.subheadline)
            }
            
            Divider()
            HTMLView(htmlContent: generateHTMLContent(content: newsItem.content, colorScheme: .dark))
                .frame(maxWidth: .infinity)
                .navigationTitle(newsItem.title)
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(.black)
            Spacer()
        }
        .padding()
    }
}



struct HTMLView: UIViewRepresentable {
    let htmlContent: String
    @Environment(\.colorScheme) var colorScheme
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(generateHTMLContent(content: htmlContent, colorScheme: colorScheme), baseURL: nil)
    }
}


func generateHTMLContent(content: String, colorScheme: ColorScheme) -> String {
    var htmlContent = """
    <!DOCTYPE html>
    <html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                font-size: 20px;
                margin: 10px;
                background-color: \(colorScheme == .dark ? "#333333" : "#ffffff"); /* Changing background color depending on the current theme */
                color: \(colorScheme == .dark ? "#ffffff" : "#000000"); /* Changing text color depending on the current theme */
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
