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
    
    var storedForecasts = Results<Forecast>?()
    var daysForecasts = [Forecast]()
    
    override func viewDidLoad() {
        collectionView.configureLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        let realm = try! Realm()
        storedForecasts = realm.objects(Forecast)
        collectionView.reloadData()
        let params = ["q":"Chisinau",
            "appid": APIkey,
            "units": "metric",
            "cnt" : "4",
            "mode": "json"]
        
        RequestDispatcher.sharedInstance.performRequest(MyEndpoint.ForecastByDays, parameters: params) { [unowned self] (result : [Forecast]?, error : NSError?) -> Void in
            if let result = result {
                self.daysForecasts = result
            self.collectionView.reloadSections(NSIndexSet.init(index: 0))
//                print(self.daysForecasts)
            }
        }
        
        print(storedForecasts)
    }
}

extension MainViewController : UICollectionViewDataSource {
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (storedForecasts?.count)!
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("forecastCollectionCell", forIndexPath: indexPath)  as! ForecastCollectionCell
        cell.tempLabel.text = "\(storedForecasts![indexPath.row].name) \(storedForecasts![indexPath.row].main!.temp) C\u{02DA}" ?? ""
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
        return daysForecasts.count
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell")
//        let text = storedForecasts![indexPath.row].weather[0].descriptionWeather ?? ""
//        cell?.textLabel?.text = text
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


