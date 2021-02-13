//
//  NewsCell.swift
//  news
//
//  Created by Саша Дранчук on 13.02.2021.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsSource: UILabel!
    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    
    func updateCell(article: Article) {
        newsTitle?.text = article.title ?? ""
        newsSource?.text = article.source.name ?? ""
        newsAuthor?.text = article.author ?? ""
        newsDescription?.text = article.description ?? ""
    }
}
