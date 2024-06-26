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
    @Environment(\.colorScheme) var colorScheme
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
                    Link(LocalizedStringKey("Go to the link"), destination: url)
                        .font(.subheadline)
                        .tint(.red)
                } else {
                    // Handling the case when the URL is nil
                    Text(LocalizedStringKey("No link available"))
                        .font(.subheadline)
                }
                Spacer()
                Text("Date:")
                    .bold()
                Text(newsItem.date)
                    .font(.subheadline)
            }
            
            Divider()
            HTMLView(htmlContent: generateHTMLContent(content: newsItem.content, colorScheme: colorScheme))
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

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(generateHTMLContent(content: htmlContent, colorScheme: colorScheme), baseURL: nil)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HTMLView

        init(_ parent: HTMLView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            // Открывать ссылки во внешнем браузере
            if navigationAction.navigationType == .linkActivated {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
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
                background-color: \(colorScheme == .dark ? "#000000" : "#ffffff"); /* Changing background color depending on the current theme */
                color: \(colorScheme == .dark ? "#ffffff" : "#000000"); /* Changing text color depending on the current theme */
            }
            img {
                max-width: 100%;
                height: auto;
            }
            a {
                color: \(colorScheme == .dark ? "#FF2600" : "#FF2600"); /* Url color */
                text-decoration: underline;
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
