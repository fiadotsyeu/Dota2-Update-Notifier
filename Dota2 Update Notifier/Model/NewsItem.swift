//
//  NewsItem.swift
//  Dota2 Update Notifier
//
//  Created by user on 09.04.2024.
//

import Foundation

var counter = 0

struct NewsItem: Codable, Identifiable, Hashable {
    var id: Int?
    var title: String
    var date: String
    var content: String
    var url: URL?
    var imageURL: URL?
    var isFavorite: Bool
    var tag: String
    
    init(title: String, date: String, content: String, url: URL? = nil, imageURL: URL? = nil, isFavorite: Bool, tag: String) {
        self.title = title
        self.date = date
        self.content = content
        self.url = url
        self.imageURL = imageURL
        self.isFavorite = isFavorite
        self.tag = tag
        self.id = generateUniqueInt()
    }
    
    private func generateUniqueInt() -> Int {
        counter += 1
        return counter
    }
}
