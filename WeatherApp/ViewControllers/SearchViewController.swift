//
//  SecondViewController.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/14/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import UIKit
import Bond

class SearchViewController: UIViewController {
    
    private var searchViewModel = SearchViewModel()
    
    private var filteredCities : [City] = [City]()
    
    private var repo = GenericRepository<QueryImpl, City>()
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var matchesTableView: UITableView!
    
    override func viewDidLoad() {
        
        searchViewModel.searchText.bidirectionalBindTo(searchTextField.bnd_text)
    }
    
}

extension SearchViewController : UITextFieldDelegate {
//    internal func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(SearchViewController.performSearch), object: nil)
//        performSelector(#selector(SearchViewController.performSearch), withObject: nil, afterDelay: 0.3)
//        matchesTableView.reloadData()
//    }
    
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


