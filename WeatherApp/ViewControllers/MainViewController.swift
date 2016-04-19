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
    
    var viewModel: ViewModel!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel()
        viewModel.configureCollectionView(collectionView)
        self.navigationController?.delegate = self
        //        let nc = NSNotificationCenter.defaultCenter()
        //        nc.addObserver(self, selector: #selector(MainViewController.showAlertController), name: "NetworkError", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
        print("viewWillAppear")
        viewModel.refresh()
        print("count: \(viewModel.cities.count)")
        collectionView.reloadData()
    }
    
    
    //        placeHolderLabel.hidden = false
    
    //        if self.cities.count != 0 { placeHolderLabel.hidden = true }
}

extension MainViewController : UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
//        print("willShowViewController")
//        self.viewWillAppear(animated)
    }
}

extension MainViewController {
    @IBAction func deleteItemAction(sender: UIButton) {
        
        if let selectedCell = sender.getForecastCell() {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Remove the city from list",
                                                    preferredStyle:.Alert)
            
            //            let destroyAction = UIAlertAction(title: "Remove", style:.Destructive) {[weak self] (action) in
            //                if let strongSelf = self {
            //                        let indexPath = strongSelf.collectionView.indexPathForCell(selectedCell)
            //                        let selectedCity = strongSelf.cities[(indexPath?.row)!]
            //                        strongSelf.cities.removeAtIndex((indexPath?.row)!)
            //                        strongSelf.repo.deleteObject(selectedCity)
            //                        strongSelf.collectionView.reloadData()
            //
            //                        if strongSelf.cities.count == 0 {
            //                            strongSelf.placeHolderLabel.hidden = false
            //                        }
            //                }
            //            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            //            alertController.addAction(destroyAction)
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
        return viewModel.cities.count
    }
    
    internal func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("forecastCollectionCell",
                                                                         forIndexPath: indexPath) as! ForecastCollectionCell
        
        cell.tempLabel.text = viewModel.titleTextForCity(indexPath.row)
        
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

//MARK: - Table View Data Source

extension MainViewController : UITableViewDataSource {
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities[tableView.tag].forecasts.count
    }
    
    internal func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dailyCell") as! DailyForecastCell
        cell.selectionStyle = .None
        let city = viewModel.cities[tableView.tag]
        let forecast = city.forecasts[indexPath.row]
        cell.dayLabel?.text = viewModel.forecastCellText(forecast)
        
        viewModel.imageForForecast(forecast) { (image) in
            cell.iconImageView?.image = image
            cell.iconImageView?.setNeedsDisplay()
        }
        
        return cell
    }
}