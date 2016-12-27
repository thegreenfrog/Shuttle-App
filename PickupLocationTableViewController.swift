//
//  PickupLocationTableViewController.swift
//  Shuttle_Application
//
//  Created by James Boyle on 6/6/16.
//
//

import UIKit
import CoreLocation

class PickupLocationTableViewController: UITableViewController, UISearchBarDelegate {
    
    var locationArray = [PickupLocation]()
    
    var filteredLocations = [PickupLocation]()
    
    var classVarUserTappedLocation: String?
    
    var searchController: UISearchController?
    let locationManager = CLLocationManager()
    
    var shouldShowSearchResults = false
    
    struct Constants {
        
        static let NUMBER_OF_ROWS = 28
    }
    
    func pickUpUser(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureSearchController()
        
        //On tap, get user location, send to nearest driver
   //     delegate!.myVCDidFinish("dsad")
        
        
        initializeLocationArray()
        
        navigationItem.title = "Where are you?"
        
        tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "cellId")
        tableView.registerClass(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        
        tableView.sectionHeaderHeight = 50
        
    }
    
//MARK -- TableView 
    
    func initializeLocationArray(){
        
        locationArray.append(PickupLocation(name: "52 Harpswell")!)
        locationArray.append(PickupLocation(name: "Appleton")!) //PickupLocation(name: "Appleton")!
        locationArray.append(PickupLocation(name: "Baxter")!)
        locationArray.append(PickupLocation(name: "Brunswick")!)
        locationArray.append(PickupLocation(name: "Burn")!) //PickupLocation(name: "Appleton")!
        locationArray.append(PickupLocation(name: "Chambo")!) //PickupLocation(name: "Appleton")!
        locationArray.append(PickupLocation(name: "Cleaveland")!)
        locationArray.append(PickupLocation(name: "Coleman")!)
        locationArray.append(PickupLocation(name: "Coles Tower")!)
        locationArray.append(PickupLocation(name: "Harpswell Apartments")!)
        locationArray.append(PickupLocation(name: "Helm")!)
        locationArray.append(PickupLocation(name: "Howard")!)
        locationArray.append(PickupLocation(name: "Howell")!)
        locationArray.append(PickupLocation(name: "Hyde")!)
        locationArray.append(PickupLocation(name: "Ladd")!)
        locationArray.append(PickupLocation(name: "Mac House")!)
        locationArray.append(PickupLocation(name: "Maine")!)
        locationArray.append(PickupLocation(name: "Mayflower")!)
        locationArray.append(PickupLocation(name: "Moore")!)
        locationArray.append(PickupLocation(name: "Osher")!)
        locationArray.append(PickupLocation(name: "Pine")!)
        locationArray.append(PickupLocation(name: "Quinby")!)
        locationArray.append(PickupLocation(name: "Reed")!)
        locationArray.append(PickupLocation(name: "Smith House")!)
        locationArray.append(PickupLocation(name: "Stowe Hall")!)
        locationArray.append(PickupLocation(name: "Stowe Inn")!)
        locationArray.append(PickupLocation(name: "West")!)
        locationArray.append(PickupLocation(name: "Winthrop")!)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults && self.searchController?.searchBar.text! != "" {
            return filteredLocations.count
        }
        else{
            return Constants.NUMBER_OF_ROWS
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //code
        
        //switch indexPath
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        switch indexPath.row {
        case 0:
            appDelegate.shouldNotBeDoingThis = locationArray[0].name
            self.tabBarController?.selectedIndex = 1
            break
        case 1:
            appDelegate.shouldNotBeDoingThis = locationArray[1].name
            self.tabBarController?.selectedIndex = 1
            break
        case 2:
            appDelegate.shouldNotBeDoingThis = locationArray[2].name
            self.tabBarController?.selectedIndex = 1
            break
        case 3:
            appDelegate.shouldNotBeDoingThis = locationArray[3].name
            self.tabBarController?.selectedIndex = 1
            break
        case 4:
            appDelegate.shouldNotBeDoingThis = locationArray[4].name
            self.tabBarController?.selectedIndex = 1
            break
        case 5:
            appDelegate.shouldNotBeDoingThis = locationArray[5].name
            self.tabBarController?.selectedIndex = 1
            break

        case 6:
            appDelegate.shouldNotBeDoingThis = locationArray[6].name
            self.tabBarController?.selectedIndex = 1
            break

        case 7:
            appDelegate.shouldNotBeDoingThis = locationArray[7].name
            self.tabBarController?.selectedIndex = 1
            break

        case 8:
            appDelegate.shouldNotBeDoingThis = locationArray[8].name
            self.tabBarController?.selectedIndex = 1
            break

        case 9:
            appDelegate.shouldNotBeDoingThis = locationArray[9].name
            self.tabBarController?.selectedIndex = 1
            break
        case 10:
            appDelegate.shouldNotBeDoingThis = locationArray[10].name
            self.tabBarController?.selectedIndex = 1
            break
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell =  tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as! CustomCell
        
        if shouldShowSearchResults && self.searchController?.searchBar.text! != "" {
            cell.textLabel?.text = filteredLocations[indexPath.row].name
        }
        else if shouldShowSearchResults {
            cell.textLabel?.text = locationArray[indexPath.row].name
        }
        else{
            cell.textLabel?.text = locationArray[indexPath.row].name
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier("headerId")
    }

//MARK - SearchController
    
    func configureSearchController(){
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        
        searchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        self.searchController = searchController
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        self.searchController?.searchBar.resignFirstResponder()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        print(self.searchController?.searchBar.text!)
        
        filteredLocations = locationArray.filter({( location) -> Bool in
            let locationText: NSString = location.name
            return (locationText.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        tableView.reloadData()
    }

}

class Header: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "College Housing"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
    }

}

class CustomCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
       // label.text = "Sample"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))

    }
    
}

extension PickupLocationTableViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if self.searchController?.searchBar.text! != "" {
            
            filterContentForSearchText(self.searchController!.searchBar.text!)
        }
    }
}