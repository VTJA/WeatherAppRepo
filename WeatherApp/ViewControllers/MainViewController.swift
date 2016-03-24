//
//  ViewController.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/11/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var cities = [City]()
    private var forecasts = [Forecast]()
    private let repo = GenericRepository<QueryImpl, City>()
    
    override func viewDidLoad() {
        collectionView.configureLayout()
        print("hello")
    }
    
    override func viewWillAppear(animated: Bool) {
        CachingManager.sharedInstance.updateCacheIfNeed { (cities) in
            self.cities = cities
            self.collectionView.reloadData()
        }
    }
}

extension MainViewController : UICollectionViewDataSource {
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("forecastCollectionCell", forIndexPath: indexPath)  as! ForecastCollectionCell
        cell.tempLabel.text = " \(cities[indexPath.row].name)"
        cell.setTableViewDataSourceDelegate(self, forRow: indexPath.row)
        return cell
    }
}

extension MainViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities[tableView.tag].forecasts.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")
        
        let city = cities[tableView.tag]
        let forecast = city.forecasts[indexPath.row]
        
        cell?.textLabel?.text = "\(forecast.temp?.day)"
        return cell!
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.collectionView.bounds.size
    }
}

extension UICollectionView {
    internal func configureLayout() {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionViewLayout = layout
    }
}
