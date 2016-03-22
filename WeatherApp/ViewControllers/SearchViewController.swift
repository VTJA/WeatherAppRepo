//
//  SecondViewController.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/14/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var matchesTableView: UITableView!
    
    private var filteredCities : [City] = [City]()
    
    func performSearch() {
        if (searchBar.text!.characters.count > 3) {
            
            let params = ["q":searchBar.text!,
                "appid": APIkey,
                "units": "metric",
                "type": "like" ,
                "mode": "json"]
            
            RequestDispatcher.sharedInstance.performRequest(MyEndpoint.Search, parameters: params)
                {[unowned self] (result : [City]?, error : NSError?) -> Void in
                    
                    if let filteredCities = result {
                        print(filteredCities)
                        self.filteredCities = filteredCities
                    } else {
                        print(error?.description)
                    }
                    
                    self.matchesTableView.reloadData()
            }
        }
    }
}

extension SearchViewController : UISearchBarDelegate {
    internal func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(SearchViewController.performSearch), object: nil)
        performSelector(#selector(SearchViewController.performSearch), withObject: nil, afterDelay: 0.3)
        
        if searchBar.text?.characters.count < 3 {
            filteredCities = [City]()
        }
        matchesTableView.reloadData()
    }
}

extension SearchViewController : UITableViewDataSource {
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = self.filteredCities[indexPath.row].name
        cell.textLabel!.sizeToFit()
        return cell;
    }
}

extension SearchViewController : UITableViewDelegate {
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        DataBaseManager.sharedInstance.store(self.filteredCities[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
}


