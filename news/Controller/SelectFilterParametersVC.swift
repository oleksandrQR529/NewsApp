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
    private var requestHead = "q="
    private var unwindId = ""
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
            unwindId = "unwindFromFilterVC"
            break
        case "Country":
            getCountry()
            unwindId = "unwindFromFilterVC"
            break
        case "Sources":
            request = ""
            getSources()
            unwindId = "unwindFromNewsVC"
        default:
            break
        }
    }
    
}

extension SelectFilterParametersVC {
    
    private func getCategories() {
        filterParameters = NetworkService.instance.categories
        requestHead = "category="
    }
    
    private func getCountry() {
        filterParameters = NetworkService.instance.countries
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
        if let destination = segue.destination as? NewsVC {
            destination.appendRequest(request: request!)
        }else if let destination = segue.destination as? FilterVC {
            destination.request.append(request!)
        }
        
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
        request = requestHead + cell.filterTypeLbl.text! + NetworkService.instance.requestEnd
        cell.accessoryType = .checkmark
        
        self.performSegue(withIdentifier: unwindId, sender: self)
    }
    
}
