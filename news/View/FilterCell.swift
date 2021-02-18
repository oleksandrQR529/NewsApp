//
//  FilterCell.swift
//  news
//
//  Created by Саша Дранчук on 18.02.2021.
//

import UIKit

class FilterCell: UITableViewCell {
    @IBOutlet weak var filterTypeLbl: UILabel!
    
    func updateCell(_ type: String) {
        filterTypeLbl.text = type
    }
    
}
