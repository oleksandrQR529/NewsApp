//
//  News.swift
//  news
//
//  Created by Саша Дранчук on 26.11.2020.
//

import Foundation

//struct Articles: Codable{
//    let articles: [Article]
//}

struct Article: Codable {
    var source: Source
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}
