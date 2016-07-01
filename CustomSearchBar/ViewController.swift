//
//  ViewController.swift
//  CustomSearchBar
//
//  Created by Gabriel Theodoropoulos on 8/9/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tblSearchResults: UITableView!
	
	// var searchController: UISearchController!
	var customSearchController: CustomSearchController!
	var dataArray = [String]()
	var filteredArray = [String]()
	
	var shouldShowSearchResults = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		loadListOfCountries()
		// configureSearchController()
		configureCustomSearchController()
		tblSearchResults.delegate = self
		tblSearchResults.dataSource = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func loadListOfCountries() {
		// Specify the path to the countries list file.
		let pathToFile = NSBundle.mainBundle().pathForResource("countries", ofType: "txt")
		
		if let path = pathToFile {
			do {
				// Load the file contents as a string.
				let countriesString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
				
				// Append the countries from the string to the dataArray array by breaking them using the line change character.
				dataArray = countriesString.componentsSeparatedByString("\n")
				
				// Reload the tableview.
				tblSearchResults.reloadData()
			} catch {
				
			}
		}
	}
	
	// func configureSearchController() {
	// searchController = UISearchController(searchResultsController: nil)
	// searchController.searchResultsUpdater = self
	// searchController.dimsBackgroundDuringPresentation = true
	// searchController.searchBar.placeholder = "Search here..."
	// searchController.searchBar.delegate = self
	// searchController.searchBar.sizeToFit()
	// tblSearchResults.tableHeaderView = searchController.searchBar
	// }
	
	func configureCustomSearchController() {
		customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRectMake(0.0, 0.0, tblSearchResults.frame.size.width, 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.orangeColor(), searchBarTintColor: UIColor.blackColor())
		
		customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
		tblSearchResults.tableHeaderView = customSearchController.customSearchBar
		customSearchController.customDelegate = self
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		if !shouldShowSearchResults {
			shouldShowSearchResults = true
			tblSearchResults.reloadData()
		}
		
		// searchController.searchBar.resignFirstResponder()
		customSearchController.searchBar.resignFirstResponder()
	}
	
	// MARK: UITableView Delegate and Datasource functions
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if shouldShowSearchResults {
			return filteredArray.count
		}
		else {
			return dataArray.count
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath)
		
		if shouldShowSearchResults {
			cell.textLabel?.text = filteredArray[indexPath.row]
		}
		else {
			cell.textLabel?.text = dataArray[indexPath.row]
		}
		
		return cell
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 60.0
	}
}

extension ViewController: UISearchResultsUpdating {
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		let searchString = searchController.searchBar.text
		
		// Filter the data array and get only those countries that match the search text.
		filteredArray = dataArray.filter({ (country) -> Bool in
			let countryText: NSString = country
			
			return (countryText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
		})
		
		// Reload the tableview.
		tblSearchResults.reloadData()
	}
}

extension ViewController: UISearchBarDelegate {
	func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
		shouldShowSearchResults = true
		tblSearchResults.reloadData()
	}
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		shouldShowSearchResults = false
		tblSearchResults.reloadData()
	}
}

extension ViewController: CustomSearchControllerDelegate {
	func didStartSearching() {
		shouldShowSearchResults = true
		tblSearchResults.reloadData()
	}
	func didTapOnSearchButton() {
		if !shouldShowSearchResults {
			shouldShowSearchResults = true
			tblSearchResults.reloadData()
		}
	}
	func didTapOnCancelButton() {
		shouldShowSearchResults = false
		tblSearchResults.reloadData()
	}
	func didChangeSearchText(searchText: String) {
		// Filter the data array and get only those countries that match the search text.
		filteredArray = dataArray.filter({ (country) -> Bool in
			let countryText: NSString = country
			
			return (countryText.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
		})
		
		// Reload the tableview.
		tblSearchResults.reloadData()
	}
}

