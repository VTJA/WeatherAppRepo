//
//  ViewController.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/11/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import UIKit
import RealmSwift

final class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var cities = Results<City>?()
    private var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        collectionView.configureLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        let realm = try! Realm()
        cities = realm.objects(City)
        collectionView.reloadData()
        
        if cities?.count != 0 {
            let city = cities!.first!
            let params : [String : AnyObject] = ["q":city.name,
                                                 "appid": APIkey,
                                                 "units": "metric",
                                                 "cnt" : "4",
                                                 "mode": "json"]
            
            RequestDispatcher.sharedInstance.performRequest(MyEndpoint.ForecastByDays, parameters: params) { (result : [Forecast]?, error:  NSError?) in
                if let result = result {
                    self.forecasts = result
                    DataBaseManager.sharedInstance.store(self.forecasts[0])
                    print(self.forecasts)
                }
            }
        }
    }
}

extension MainViewController : UICollectionViewDataSource {
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cities?.count)!
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("forecastCollectionCell", forIndexPath: indexPath)  as! ForecastCollectionCell
        cell.tempLabel.text = " \(cities![indexPath.row].name) C\u{02DA}" ?? ""
        //        cell.tempLabel.text = "                cell?.textLabel?.text = storedForecasts![indexPath.row].name C\u{02DA}" ?? ""
        return cell
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.collectionView.bounds.size
    }
}

extension MainViewController : UITableViewDataSource {
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")
        return cell!
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
