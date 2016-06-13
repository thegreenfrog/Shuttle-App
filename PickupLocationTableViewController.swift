//
//  PickupLocationTableViewController.swift
//  Shuttle_Application
//
//  Created by James Boyle on 6/6/16.
//
//

import UIKit

class PickupLocationTableViewController: UITableViewController {

    var locationArray = [PickupLocation]()
    
    var filteredLocations = [PickupLocation]()
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredLocations = locationArray.filter { location in return location.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
        
    }
    
    func initializeLocationArray(){
        
        locationArray.append(PickupLocation(name: "Appleton")!) //PickupLocation(name: "Appleton")!
        locationArray.append(PickupLocation(name: "Brunswick")!) //PickupLocation(name: "Appleton")!
        locationArray.append(PickupLocation(name: "Coleman")!) //PickupLocation(name: "Appleton")!
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeLocationArray()
        
        navigationItem.title = "Stuff"
        
        tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "cellId")
        tableView.registerClass(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        
        tableView.sectionHeaderHeight = 50
        
        
        //Search
        
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    struct Constants {
        static let NUMBER_OF_ROWS = 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.NUMBER_OF_ROWS
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell =  tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath)
        
        let location = locationArray[indexPath.row]
        cell.textLabel!.text = location.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier("headerId")
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
        label.text = "Header"
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
        filterContentForSearchText(searchController.searchBar.text!)
    }
}