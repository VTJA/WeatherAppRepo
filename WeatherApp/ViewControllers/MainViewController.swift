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
    private var photos = [FlickrPhoto]()
}

extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.configureLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        CachingManager.sharedInstance.updateCacheIfNeed { (cities) in
            self.cities = cities
            self.collectionView.reloadData()
        }
    }
}

extension MainViewController {
    @IBAction func deleteItemAction(sender: UIButton) {
        if let selectedCell = sender.getForecastCell() {
            
            let alertController = UIAlertController(title: "Warning", message: "Remove the city from list", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            
            let destroyAction = UIAlertAction(title: "Remove", style: .Destructive) { (action) in
                let indexPath = self.collectionView.indexPathForCell(selectedCell)
                let selectedCity = self.cities[(indexPath?.row)!]
                self.cities.removeAtIndex((indexPath?.row)!)
                self.repo.deleteObject(selectedCity)
                self.collectionView.reloadData()
            }
            alertController.addAction(destroyAction)
            
            self.presentViewController(alertController, animated: true) {
            }
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
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("forecastCollectionCell", forIndexPath: indexPath)  as! ForecastCollectionCell
        
        let city = cities[indexPath.row]
        
        CachingManager.sharedInstance.getCityPhotos(city) { (photo) in
            city.photo = photo
        }
        
        if let cityPhoto = city.photo {
            
            CachingManager.sharedInstance.image(cityPhoto.id, format:"jpg", url: cityPhoto.photoUrl) { (image) in
                cell.cityImageView.image = image
                cell.cityImageView.setNeedsDisplay()
            }
        } else {
            print("photo is nil")
        }
        
        let temperatureStr = city.forecasts[0].temp!.day
        
        cell.tempLabel.text = "\(city.name) \(temperatureStr)\u{00B0} C"
        
        cell.setTableViewDataSourceDelegate(self, forRow: indexPath.row)
        
        return cell
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.collectionView.bounds.size
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


//MARK: - Table View Data Source
extension MainViewController : UITableViewDataSource {
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities[tableView.tag].forecasts.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dailyCell") as! DailyForecastCell
        cell.selectionStyle = .None
        let city = cities[tableView.tag]
        let forecast = city.forecasts[indexPath.row]
        
        let forecastString = formatDate(forecast.dt)
        let temperatureString = String(NSString(format: "%.0f",(forecast.temp?.day)!))
        
        cell.dayLabel?.text = temperatureString + "\u{00B0} C " + forecastString
        
        let imageName = forecast.weather?.icon
        let url = forecast.weather?.iconURL
        
        CachingManager.sharedInstance.image(imageName!, format:"png", url:url!, withCompletion: { (image) in
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

