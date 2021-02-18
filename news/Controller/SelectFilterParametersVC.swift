//
//  SelectFilterParametersVC.swift
//  news
//
//  Created by Саша Дранчук on 18.02.2021.
//

import UIKit

class SelectFilterParametersVC: UIViewController {
    
    var filterType: String?
    private var articles: Articles?
    private var filterParameters: [String] = []
    private var request: String?
    private var categories: [String] = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    private var countries: [String] = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
    private var requestHead = "q="
    private let requestEnd = "&"
    @IBOutlet weak var parametersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initUI()
    }
    
    private func initUI() {
        self.articles = NetworkService.instance.data
        
        parametersTable.dataSource = self
        parametersTable.delegate = self
        
        switch filterType {
        case "Category":
            getCategories()
            break
        case "Country":
            getCountry()
            break
        case "Sources":
            request = ""
            getSources()
        default:
            break
        }
    }
    
}

extension SelectFilterParametersVC {
    
    private func getCategories() {
        filterParameters = categories
        requestHead = "category="
    }
    
    private func getCountry() {
        filterParameters = countries
        requestHead = "country="
    }
    
    private func getSources() {
        requestHead = "sources="
        articles?.articles.forEach { article in
            if let item = article.source.id {
                filterParameters.append(item)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NewsVC else { return }
        destination.requests = []
        destination.requests.append(destination.topHeadlinesUrl)
        destination.requests.append(request!)
        destination.requests.append(destination.sortBy)
        destination.requests.append(destination.apiKey)
        print("Request: \(destination.requests)")
        destination.searchNews()
    }
    
}

//MARK:- Data source & delegate extensions
extension SelectFilterParametersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterParameters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ParameterCell") as? FilterCell {
            cell.updateCell(filterParameters[indexPath.row])
            return cell
        }else {
            return FilterCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterCell else { return }
        request = requestHead + cell.filterTypeLbl.text! + requestEnd
        cell.accessoryType = .checkmark
        
        self.performSegue(withIdentifier: "unwindFromNewsVC", sender: self)
    }
    
}
