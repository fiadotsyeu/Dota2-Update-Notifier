//
//  RSSParser.swift
//  Dota2 Update Notifier
//
//  Created by user on 19.04.2024.
//

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    var parser: XMLParser?
    var currentElement: String?
    var currentTitle: String = ""
    var currentDescription: String = ""
    var currentPubDate: String = ""
    var currentLink: String = ""
    var currentImgURL: String = ""
    
    var titles: [String] = []
    var descriptions: [String] = []
    var pubDates: [String] = []
    var links: [String] = []
    var imgURLs: [String] = []
    
    var modelData: ModelData
    
    init(modelData: ModelData) {
        self.modelData = modelData
    }
    
    func parseRSS(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching RSS data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received from RSS feed")
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            // Сбросить текущие значения перед началом нового элемента <item>
            currentTitle = ""
            currentDescription = ""
        }
        if elementName == "enclosure" {
            if let url = attributeDict["url"] {
                currentImgURL = url
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "title" {
            currentTitle += string.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if currentElement == "description" {
            currentDescription += string
        } else if currentElement == "pubDate" {
            currentPubDate += string.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if currentElement == "guid" {
            currentLink += string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let newsItem = NewsItem(title: currentTitle, date: currentPubDate, content: currentDescription, url: URL(string: currentLink), imageURL: URL(string: currentImgURL), isFavorite: false, tag: "ss")
            if !dublicateFinder(title: newsItem.title) {
                modelData.newsItems.append(newsItem)
                currentTitle = ""
                currentDescription = ""
                currentPubDate = ""
                currentLink = ""
                currentImgURL = ""
            }
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentLink = ""
            currentImgURL = ""
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        modelData.save()
        print(modelData.newsItems.count)
    }
    
    func dublicateFinder(title: String) -> Bool {
        return modelData.newsItems.contains { $0.title == title }
    }

}



