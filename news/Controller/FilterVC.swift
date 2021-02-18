//
//  FilterVC.swift
//  news
//
//  Created by Саша Дранчук on 18.02.2021.
//

import UIKit

class FilterVC: UIViewController {
    
    private let filterTypes: [String] = ["Category", "Country", "Sources"]
    @IBOutlet weak var filterTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    private func initUI() {
        filterTable.dataSource = self
        filterTable.delegate = self
    }
    
}

extension FilterVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SelectFilterParametersVC else { return }
        let cell = filterTable.cellForRow(at: filterTable.indexPathForSelectedRow!) as? FilterCell
        destination.filterType = cell?.filterTypeLbl.text ?? ""
    }
}

//MARK:- Data source & delegate extensions
extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as? FilterCell {
            cell.updateCell(filterTypes[indexPath.row])
            cell.accessoryType = .disclosureIndicator
            return cell
        }else {
            return FilterCell()
        }
    }
}
