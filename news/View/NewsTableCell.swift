//
//  NewsTableCellTableViewCell.swift
//  news
//
//  Created by Саша Дранчук on 26.11.2020.
//

import UIKit

class NewsTableCell: UITableViewCell {
    @IBOutlet weak var newsImg: UIImageView?
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsSource: UILabel!
    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    
    func updateCell(article: Article) {
        newsTitle?.text = article.title
        newsSource?.text = article.source.name
        newsAuthor?.text = article.author
        newsDescription?.text = article.description
        newsImg?.loadImgFromUrl(urlString: article.urlToImage)
    }
}
