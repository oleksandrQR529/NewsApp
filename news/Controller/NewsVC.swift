//
//  NewsVCViewController.swift
//  news
//
//  Created by Саша Дранчук on 26.11.2020.
//

import UIKit

class NewsVC: UIViewController {
    
    @IBOutlet weak var newsTable: UITableView!
    
    private var articles = Array<Article>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    func initUI() {
        getArticles()
        
        newsTable.dataSource = self
        newsTable.delegate = self
    }
    
    func getArticles() {
        NetworkService.instance.getArticles(dataUrl: "dataURl") { (articles) in
            self.articles = articles.items
        } onError: { (errorMessage) in
            debugPrint(errorMessage)
        }

    }
    
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsTableCell {
            cell.updateCell(article: articles[indexPath.row])
            return cell
        }else {
            return NewsTableCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (newsTable.contentSize.height - 100 - scrollView.frame.size.height) {
            //fetch more data
            self.newsTable.tableFooterView = createSpinnerFooter()
        }
        DispatchQueue.main.async {
            self.newsTable.tableFooterView = nil //when load data finished
        }
    }
    
}

extension NewsVC {
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
}
