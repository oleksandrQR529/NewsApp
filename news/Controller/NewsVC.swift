//
//  NewsVCViewController.swift
//  news
//
//  Created by Саша Дранчук on 26.11.2020.
//

import UIKit

class NewsVC: UIViewController {
    
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var articles: [Article] = []
    private var findItems: [Article] = []
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
        
        searchBar.delegate = self
    }
    
}

extension NewsVC {
    
    func getArticles() {
        NetworkService.instance.getArticles(dataUrl: "http://newsapi.org/v2/top-headlines?country=us&apiKey=5dd4f29e438c40c88e31f174aab969c0") { (articles) in
            self.articles = articles.articles
            
            self.addNumberOfItems()
            
            self.sortNewsByPublishedDate()
            self.newsTable.reloadData()
        } onError: { (errorMessage) in
            debugPrint(errorMessage)
        }

    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        getArticles()
        sender.endRefreshing()
    }
    
    func searchNews(request: String) {
        numberOfItemsInSection = 0
        findItems = []
        articles.forEach { article in
            if (article.description?.contains(request) ?? false) {
                findItems.append(article)
            }
        }
        articles = findItems
        addNumberOfItems()
        newsTable.reloadData()
        newsTable.tableFooterView?.isHidden = true
    }
    
    func sortNewsByPublishedDate() {
        articles.sort { (article, articleNext) -> Bool in
            article.publishedAt! > articleNext.publishedAt!
        }
    }
    
    func addNumberOfItems() {
        numberOfItemsInSection += 5
        if numberOfItemsInSection >= articles.count {
            numberOfItemsInSection = articles.count
        }
    }
    
}

//MARK:- Data source & delegate extensions

extension NewsVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfItemsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if articles[indexPath.row].urlToImage != nil {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImgCell") as? NewsImgCell {
                cell.updateCell(article: articles[indexPath.row])
                return cell
            }else {
                return NewsImgCell()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == numberOfItemsInSection - 1 && numberOfItemsInSection != articles.count {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            self.newsTable.tableFooterView = spinner
            self.newsTable.tableFooterView?.isHidden = false
        }else {
            self.newsTable.tableFooterView?.isHidden = true
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        WebKitVC.urlString = articles[indexPath.row].url
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        addNumberOfItems()
        newsTable.reloadData()
    }
    
}

extension NewsVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchNews(request: searchBar.text ?? "")
    }
    
}
