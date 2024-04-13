//
//  NewsItem.swift
//  Dota2 Update Notifier
//
//  Created by user on 09.04.2024.
//

import Foundation

struct NewsItem: Codable {
    var id: UUID
    var title: String
    var leadIn: String
    var date: String
    var content: String
    var url: URL
    var imageURL: URL
    var language: String
    var isFavorite: Bool
}
