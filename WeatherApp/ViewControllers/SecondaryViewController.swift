//
//  SecondViewController.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/14/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import UIKit

class SecondaryViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var matchesTableView: UITableView!
    
    var filteredCities : [Forecast] = [Forecast]()
    
    func performSearch() {
        if (searchBar.text!.characters.count > 3) {
            
            let params = ["q":searchBar.text!,
                "appid": APIkey,
                "units": "metric",
                "type": "like" ,
                "mode": "json"]
            
            RequestDispatcher.sharedInstance.performRequest(MyEndpoint.Search, parameters: params)
                { (result : [Forecast]?, error : NSError?) -> Void in
                    
                    if let filteredCities = result {
                        self.filteredCities = filteredCities.filter { $0.name.characters.count > 0 }
                    }
                    
                    self.matchesTableView.reloadData()
            }
        }
    }
}

extension SecondaryViewController : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "performSearch", object: nil)
        performSelector("performSearch", withObject: nil, afterDelay: 0.3)
        
        if (searchBar.text?.characters.count < 3) {
            filteredCities = [Forecast]()
        }
        matchesTableView.reloadData()
    }
}

extension SecondaryViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : SearchResultCell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! SearchResultCell
        cell.tempLabel.text = "\(self.filteredCities[indexPath.row].main!.temp) C\u{02DA}"
        cell.nameLabel.text = self.filteredCities[indexPath.row].name
        return cell;
    }
}

extension SecondaryViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        DataBaseManager.sharedInstance.store(self.filteredCities[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
}
