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
    @IBOutlet weak var placeHolderLabel: UILabel!
    private var cities = [City]()
    private var forecasts = [Forecast]()
    private let repo = GenericRepository<QueryImpl, City>()
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.configureLayout()
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(MainViewController.showAlertController), name: "NetworkError", object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        CachingManager.sharedInstance.updateCacheIfNeed {[weak self] (cities) in
            if let strongSelf = self {
                strongSelf.cities = cities
                strongSelf.collectionView.reloadData()
            }
        }
        placeHolderLabel.hidden = false
        if self.cities.count != 0 { placeHolderLabel.hidden = true }
    }
    func showAlertController() -> () {
        let alertController = UIAlertController(title: "Oops",
                                                message: "Something went wrong",
                                                preferredStyle:.Alert)
         let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension MainViewController {
    @IBAction func deleteItemAction(sender: UIButton) {
        if let selectedCell = sender.getForecastCell() {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Remove the city from list",
                                                    preferredStyle:.Alert)
            let destroyAction = UIAlertAction(title: "Remove", style:.Destructive) {[weak self] (action) in
                if let strongSelf = self {
                        let indexPath = strongSelf.collectionView.indexPathForCell(selectedCell)
                        let selectedCity = strongSelf.cities[(indexPath?.row)!]
                        strongSelf.cities.removeAtIndex((indexPath?.row)!)
                        strongSelf.repo.deleteObject(selectedCity)
                        strongSelf.collectionView.reloadData()
                        
                        if strongSelf.cities.count == 0 {
                            strongSelf.placeHolderLabel.hidden = false
                        }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(destroyAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
extension UIView {
    func getForecastCell() -> (ForecastCollectionCell?) {
        if self.superview == nil {
            return nil
        }
        if let cell = self.superview as? ForecastCollectionCell {
            return cell
        }
        return self.superview?.getForecastCell()
    }
}

//MARK: - Collection View Data Source
extension MainViewController : UICollectionViewDataSource {
    internal func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    internal func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("forecastCollectionCell",
                                                                         forIndexPath: indexPath)  as! ForecastCollectionCell
        let city = cities[indexPath.row]
        
        if city.forecasts.count != 0 {
            if let tempStr = city.forecasts[0].temp?.day {
                cell.tempLabel.text = "\(city.name) \(tempStr)\u{00B0} C"
            }
        } else {
            cell.tempLabel.text = city.name;
        }
    
        cell.setTableViewDataSourceDelegate(self, forRow: indexPath.row)
        return cell
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    internal func collectionView(collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.collectionView.bounds.size
    }
}

extension UICollectionView {
    func configureLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionViewLayout = layout
    }
}

//MARK: - Table View Data Source
extension MainViewController : UITableViewDataSource {
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities[tableView.tag].forecasts.count
    }
    internal func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dailyCell") as! DailyForecastCell
        cell.selectionStyle = .None
        let city = cities[tableView.tag]
        let forecast = city.forecasts[indexPath.row]
        let forecastString = formatDate(forecast.dt)
        let temperatureString = String(NSString(format: "%.0f",(forecast.temp?.day)!))
        cell.dayLabel?.text = temperatureString + "\u{00B0} C " + forecastString
        let imageName = forecast.weather?.icon
        let url = forecast.weather?.iconURL
        CachingManager.sharedInstance.image(imageName!,
                                            format:"png",
                                            url:url!,
                                            withCompletion: { (image) in
                                                cell.iconImageView?.image = image
                                                cell.iconImageView?.setNeedsDisplay()
        })
        return cell
    }
    func formatDate(date: Double) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        let dateOfForecast = NSDate(timeIntervalSince1970: date)
        let forecastString = formatter.stringFromDate(dateOfForecast)
        return forecastString
    }
}