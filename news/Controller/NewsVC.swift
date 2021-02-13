//
//  NewsVCViewController.swift
//  news
//
//  Created by Саша Дранчук on 26.11.2020.
//

import UIKit

class NewsVC: UIViewController {
    
    @IBOutlet weak var newsTable: UITableView!
    
    private var articles: [Article] = []
    private var numberOfItemsInSection = 0
    private let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    
    
    func initUI() {
        getArticles()
       
        newsTable.dataSource = self
        newsTable.delegate = self
        newsTable.refreshControl = myRefreshControl
    }
    
    func getArticles() {
        NetworkService.instance.getArticles(dataUrl: "http://newsapi.org/v2/top-headlines?country=us&apiKey=5dd4f29e438c40c88e31f174aab969c0") { (articles) in
            self.articles = articles.articles
            self.numberOfItemsInSection += 5
            if self.numberOfItemsInSection >= self.articles.count {
                self.numberOfItemsInSection = self.articles.count
            }
            self.newsTable.reloadData()
        } onError: { (errorMessage) in
            debugPrint(errorMessage)
        }

    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        getArticles()
        sender.endRefreshing()
    }
    
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfItemsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if articles[indexPath.row].urlToImage != nil {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImgCell") as? NewsTableCell {
                cell.updateCell(article: articles[indexPath.row])
                return cell
            }else {
                return NewsTableCell()
            }
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsCell {
                cell.updateCell(article: articles[indexPath.row])
                return cell
            }else {
                return NewsCell()
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        numberOfItemsInSection += 5
        if numberOfItemsInSection >= articles.count {
            numberOfItemsInSection = articles.count
        }
        newsTable.reloadData()
    }
    
}
