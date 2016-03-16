//
//  SecondViewController.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/14/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import UIKit

class SecondaryViewController: UIViewController  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var matchesTableView: UITableView!
    
    var filteredCities : [Forecast] = [Forecast]()
}

extension SecondaryViewController : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let params = ["q":searchText, "appid": APIkey, "units": "metric", "type": "like" , "mode": "json"]
        if (searchText.characters.count > 3) {
            DataParser.performRequest(MyEndpoint.Search, parameters: params) { (result : [Forecast]?, error : NSError?) -> Void in
                if let filteredCities = result {
                    self.filteredCities = filteredCities
                }
                self.matchesTableView.reloadData()
                
                if let error = error {
                    print(error.description)
                }
            }
        }
    }
}

extension SecondaryViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count == 0 ? 0 : (filteredCities.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : SearchResultCell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! SearchResultCell
        cell.tempLabel.text = "\(self.filteredCities[indexPath.row].temp) C\u{02DA}"
        cell.nameLabel.text = self.filteredCities[indexPath.row].cityName
        return cell;
    }
}