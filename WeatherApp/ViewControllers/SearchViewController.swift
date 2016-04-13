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
    
    private var repo = GenericRepository<QueryImpl, City>()
    
    func performSearch() {
        if (searchBar.text!.characters.count > 3) {
            
            let params = ["q":searchBar.text!,
                          "appid": WeatherAPIKey,
                          "units": "metric",
                          "type": "like" ,
                          "mode": "json"]
            
            RequestDispatcher.sharedInstance.performRequest(WeatherEndpoint.Search, parameters: params)
            {[weak self] (result : [City]?, error : NSError?) -> Void in
                if let strongSelf = self {
                    if let filteredCities = result {
                        strongSelf.filteredCities = filteredCities
                    } else {
                        print(error?.description)
                    }
                    strongSelf.matchesTableView.reloadData()
                }
            }
        }
    }
}

extension SearchViewController : UISearchBarDelegate {
    internal func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(SearchViewController.performSearch), object: nil)
        performSelector(#selector(SearchViewController.performSearch), withObject: nil, afterDelay: 0.3)
        
        if searchBar.text?.characters.count < 3 {
            filteredCities.removeAll()
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
        cell.selectionStyle = .None
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell;
    }
}

extension SearchViewController : UITableViewDelegate {
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !repo.storeObject(self.filteredCities[indexPath.row]) { print("error writing to the database") }
        self.navigationController?.popViewControllerAnimated(true)
    }
}


