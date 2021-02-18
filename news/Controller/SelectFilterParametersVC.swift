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
    private var request: [String] = []
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
        case "Sources":
            getSources()
            break
        default:
            break
        }
    }
    
}

extension SelectFilterParametersVC {
    
    private func getCategories() {
        articles?.articles.forEach { article in
            filterParameters.append(article.author ?? "")
        }
    }
    
    private func getSources() {
        articles?.articles.forEach { article in
            filterParameters.append(article.source.name ?? "")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NewsVC else { return }
        destination.requests = self.request
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
        request.append(cell.filterTypeLbl.text ?? "")
        cell.accessoryType = .checkmark
    }
    
}
