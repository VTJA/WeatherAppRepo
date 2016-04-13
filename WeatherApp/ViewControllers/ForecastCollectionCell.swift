//
//  ForecastCollectionCell.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/17/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import UIKit

final class ForecastCollectionCell: UICollectionViewCell {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var daysTableview: UITableView!
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var deleteButtonTop: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var shouldShowDelete: Bool = false {
        didSet {
            if shouldShowDelete {
                deleteButtonTop.constant = -deleteButton.bounds.size.height
                UIView.animateWithDuration(0.3) {
                    self.layoutIfNeeded()
                }
            } else {
                deleteButtonTop.constant = 0
                UIView.animateWithDuration(0.3) {
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
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
        
        self.deleteButtonTop.constant = 0
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        shouldShowDelete = sender.direction == .Up
    }
}
