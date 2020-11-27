//
//  News.swift
//  news
//
//  Created by Саша Дранчук on 26.11.2020.
//

import Foundation

struct Articles: Codable{
    let items: Array<Article>
}

struct Article: Codable {
    let source: Source
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: Date
    let content: String
}
