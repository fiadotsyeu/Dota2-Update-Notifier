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
    
    func parseRSS(url: URL) {
        parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            currentElement = elementName
            if elementName == "enclosure" {
                if let url = attributeDict["url"] {
                    currentImgURL = url
                }
            }
        }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "title" {
            currentTitle += string
        } else if currentElement == "description" {
            currentDescription += string
        } else if currentElement == "pubDate" {
            currentPubDate += string
        } else if currentElement == "guid" {
            currentLink += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            titles.append(currentTitle)
            descriptions.append(currentDescription)
            pubDates.append(currentPubDate)
            links.append(currentLink)
            imgURLs.append(currentImgURL)
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
            currentLink = ""
            currentImgURL = ""
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Titles: \(titles)")
        print("Descriptions: \(descriptions)")
        print("PubDate: \(pubDates)")
        print("link: \(links)")
        print("img: \(imgURLs)")
    }
    
}


