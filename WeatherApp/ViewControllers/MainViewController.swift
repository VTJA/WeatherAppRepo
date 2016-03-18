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
    var storedForecasts = Results<Forecast>?()
    var days = [Forecast]()
    
    override func viewDidLoad() {
        collectionView.configureLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        let realm = try! Realm()
        storedForecasts = realm.objects(Forecast)
        print(storedForecasts)
        collectionView.reloadData()
        
        let params = ["q":"Chisinau",
            "appid": APIkey,
            "units": "metric",
            "type": "like" ,
            "mode": "json",
            "cnt": "4"]
        
        RequestDispatcher.sharedInstance.performRequest(MyEndpoint.ForecastByDays, parameters: params) { (results : [Forecast]?, error: NSError?) -> Void in
            if let days = results {
                self.days = days
                print(self.days)
            }
        }
    }
}

extension MainViewController : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (storedForecasts?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("forecastCollectionCell", forIndexPath: indexPath)  as! ForecastCollectionCell
        cell.tempLabel.text = "\(storedForecasts![indexPath.row].cityName) \(storedForecasts![indexPath.row].temp) C\u{02DA}" ?? ""
        return cell
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.collectionView.bounds.size
    }
}

extension MainViewController : UITableViewDataSource {
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.days.count
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")
        cell?.textLabel?.text = "\(self.days[indexPath.row].dayTemp)...\(self.days[indexPath.row].nightTemp)"
        return cell!
    }
}

extension UICollectionView {
    func configureLayout() {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionViewLayout = layout
    }
}


