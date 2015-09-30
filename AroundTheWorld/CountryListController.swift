//
//  CountryListController.swift
//  AroundTheWorld
//
//  Created by Ky Nguyen on 9/25/15.
//  Copyright © 2015 Ky Nguyen. All rights reserved.
//

import UIKit



class CountryListController: UITableViewController, UISearchResultsUpdating, UINavigationControllerDelegate {

    @IBOutlet var searchBar: UISearchBar!
    var headerView: UIView?
    var headerViewShow = false
    
    var filterCountries = [Country]()
    
    @IBOutlet var countriesTable: UITableView!
    
    
    var resultSearchController = UISearchController()
    
    @IBAction func search(sender: AnyObject) {
        
        countriesTable.setContentOffset(CGPoint(x: 0, y: -65), animated: true)
    }
    
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCountriesFromService()
        
        navigationController?.delegate = self
        
        initSearchController()

        reloadData()
    }
    
    func reloadData() {
        
        self.tableView.reloadData()
    }
    
    func initSearchController() {
        
        self.resultSearchController = ({
            
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filterCountries.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "name contains[C] %@", searchController.searchBar.text!)
        let array = (countries as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filterCountries = array as! [Country]
        
        reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if resultSearchController.active {
            
            return filterCountries.count
        }
        
        return countries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("CountryCell", forIndexPath: indexPath)
        cell.textLabel?.text = getDataForCell(indexPath.row)
        
        return cell
    }

    func getDataForCell(index: Int) -> String {
        
        if self.resultSearchController.active {
            
            return filterCountries[index].name
        }
        else {
            
            return countries[index].name
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "ViewDetail" {
            
            let controller = segue.destinationViewController as! CountryDetailController
            
            controller.country = countries[tableView.indexPathForSelectedRow!.row]
        }
    }

    
    func getCountriesFromService() {
        
        let url = "https://restcountries.eu/rest/v1/all"
        
        ApiWorking.get(url) { (data) -> Void in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            
                self.parseData(data)
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.fetchDataToUI()
                }
            }
        }
    }

    
    func parseData(data: [AnyObject]) {
        
        for element: AnyObject in data {
            
            let country = Country()
            country.name = element.valueForKey("name") as! String
            country.capital = element.valueForKey("capital") as! String
            country.area = element.valueForKey("area") as? Double
            country.population = element.valueForKey("population") as? Double
            country.subRegion = element.valueForKey("subregion") as! String
            
            countries.append(country)
        }
    }
    
    func fetchDataToUI() {
        
        reloadData()
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        
        resultSearchController.active = false
    }
}
