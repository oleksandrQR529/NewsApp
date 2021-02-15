//
//  Data.swift
//  news
//
//  Created by Саша Дранчук on 12.02.2021.
//

import Foundation

struct Articles: Codable {    
    var status: String?
    var totalResults: Int?
    var articles: [Article]
}
