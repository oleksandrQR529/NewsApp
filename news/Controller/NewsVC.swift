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
    private var numberOfItemsInSection = 0
    var request: String = ""
    private let country = "country=us&"
    private var specificKeywoardToSearch = "q=Apple&"
    private let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    private func initUI() {
        getArticles(request: NetworkService.instance.topHeadlineUrl + country + NetworkService.instance.sortBy + NetworkService.instance.apiKey)
       
        newsTable.dataSource = self
        newsTable.delegate = self
        newsTable.refreshControl = myRefreshControl
        
        searchBar.delegate = self
    }
}

extension NewsVC {
    
    private func getArticles(request: String) {
        NetworkService.instance.getArticles(dataUrl: request) { (articles) in
            self.articles = articles.articles
            
            self.addNumberOfItems()
            
            self.newsTable.reloadData()
        } onError: { (errorMessage) in
            debugPrint(errorMessage)
        }

    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        getArticles(request: NetworkService.instance.topHeadlineUrl + country + NetworkService.instance.sortBy + NetworkService.instance.apiKey)
        sender.endRefreshing()
    }
    
    func searchNews() {
        numberOfItemsInSection = 0
        getArticles(request: self.request)
    }
    
    private func addNumberOfItems() {
        numberOfItemsInSection += 5
        if numberOfItemsInSection >= articles.count {
            numberOfItemsInSection = articles.count
        }
    }
    
    func appendRequest(request: String) {
        self.request = ""
        self.request.append(NetworkService.instance.topHeadlineUrl)
        self.request.append(request)
        self.request.append(NetworkService.instance.sortBy)
        self.request.append(NetworkService.instance.apiKey)
        searchNews()
    }
    
    @IBAction func unwindFromNewsVC(unwindSegue: UIStoryboardSegue){}
    
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
            let spinner = UIActivityIndicatorView(style: .gray)
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
        request = ""
        request.append(NetworkService.instance.everythingUrl)
        specificKeywoardToSearch = "q=" + (searchBar.text ?? "") + "&"
        request.append(specificKeywoardToSearch)
        request.append(NetworkService.instance.apiKey)
        self.searchNews()
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
