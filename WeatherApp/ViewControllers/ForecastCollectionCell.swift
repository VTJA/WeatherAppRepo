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
    
    @IBOutlet weak var deleteButtonTop: NSLayoutConstraint!
    
    @IBOutlet weak var deleteButton: UIButton!
    var toggleStatus : Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    func setTableViewDataSourceDelegate
        <D:UITableViewDataSource>
        (dataSourceDelegate: D, forRow row: Int) {
        tableView.dataSource = dataSourceDelegate
        tableView.tag = row
        tableView.reloadData()
    }
    
    override func awakeFromNib() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ForecastCollectionCell.handleSwipes(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ForecastCollectionCell.handleSwipes(_:)))
        
        upSwipe.direction = .Up
        downSwipe.direction = .Down
        
        self.contentView.addGestureRecognizer(upSwipe)
        self.contentView.addGestureRecognizer(downSwipe)
    }
    
    @IBAction func toggleDeleteButton(sender: UIButton) {
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Up) {
            deleteButtonTop.constant = -deleteButton.bounds.size.height
            UIView.animateWithDuration(0.3) {
                self.layoutIfNeeded()
            }
        }
        
        if (sender.direction == .Down) {
            deleteButtonTop.constant = 0
            UIView.animateWithDuration(0.3) {
                self.layoutIfNeeded()
            }
        }
    }
}
