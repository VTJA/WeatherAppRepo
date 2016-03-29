//
//  ForecastCollectionCell.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/17/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import UIKit

final class ForecastCollectionCell: UICollectionViewCell {
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var daysTableview: UITableView!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    func setTableViewDataSourceDelegate
        <D:UITableViewDataSource>
        (dataSourceDelegate: D, forRow row: Int) {
        tableView.dataSource = dataSourceDelegate
        tableView.tag = row
        tableView.reloadData()
    }
    
}
