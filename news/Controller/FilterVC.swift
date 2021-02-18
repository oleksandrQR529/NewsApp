//
//  FilterVC.swift
//  news
//
//  Created by Саша Дранчук on 18.02.2021.
//

import UIKit

class FilterVC: UIViewController {
    
    var request: String = ""
    @IBOutlet weak var filterTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    private func initUI() {
        request = ""
        request.append(NetworkService.instance.topHeadlineUrl)
        
        filterTable.dataSource = self
        filterTable.delegate = self
    }
    
}

extension FilterVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SelectFilterParametersVC {
            let cell = filterTable.cellForRow(at: filterTable.indexPathForSelectedRow!) as? FilterCell
            destination.filterType = cell?.filterTypeLbl.text ?? ""
        }else if let destination = segue.destination as? NewsVC {
            destination.appendRequest(request: self.request)
        }
        
    }
    
    @IBAction func unwindFromFilterVC(unwindSegue: UIStoryboardSegue){}
}

//MARK:- Data source & delegate extensions
extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkService.instance.filterTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as? FilterCell {
            cell.updateCell(NetworkService.instance.filterTypes[indexPath.row])
            cell.accessoryType = .disclosureIndicator
            return cell
        }else {
            return FilterCell()
        }
    }
}
