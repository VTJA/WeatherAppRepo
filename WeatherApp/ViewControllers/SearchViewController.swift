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
    
    private let searchViewModel = SearchViewModel()
    
    private var repo = GenericRepository<QueryImpl, City>()
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var matchesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        
        searchViewModel.searchText
        .bidirectionalBindTo(searchTextField.bnd_text)
        
        searchViewModel.validSearchText.map{ $0 ? UIColor.blackColor() : UIColor.redColor()}
        .bindTo(searchTextField.bnd_textColor)
        
        searchViewModel.filteredCities.lift().bindTo(matchesTableView) { indexPath, dataSource, tableView in
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            
            let city = dataSource[0][indexPath.row]
            
            cell.textLabel?.text = city.name
            
            return cell
        }
    }
}

extension SearchViewController : UITableViewDataSource {
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.filteredCities.count
    }
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        return cell;
    }
}

extension SearchViewController : UITableViewDelegate {
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if !repo.storeObject(self.filteredCities[indexPath.row]) { print("error writing to the database")}
        //TODO: Store filtered cities on selected cell
        self.navigationController?.popViewControllerAnimated(true)
    }
}


