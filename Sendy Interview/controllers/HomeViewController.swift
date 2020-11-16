//
//  HomeViewController.swift
//  Sendy Interview
//
//  Created by Boaz James on 13/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    private var locations: [NSManagedObject] = []
    private var filteredLocations: [NSManagedObject] = []
    private var lblEmptyHeightConstraint: NSLayoutConstraint!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var searchText: String? {
        return searchController.searchBar.text
    }
    
    private var lblEmpty: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Futura", size: 17)
        label.text = "You've not added any location."
        label.textAlignment = .center
        return label
    }()
    
    private var navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.isTranslucent = false
        if var textAttributes = navBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black
            navBar.titleTextAttributes = textAttributes
        }
        return navBar
    }()
    
    var navItem = {
        return UINavigationItem(title: "Home")
    }()
    
    private var tableView: UITableView = {
        let tblView = UITableView()
        tblView.allowsSelectionDuringEditing = false
        if #available(iOS 11.0, *) {
            tblView.contentInsetAdjustmentBehavior = .never
        }
        tblView.translatesAutoresizingMaskIntoConstraints = false
        return tblView
    }()
    
    var layoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide
        } else {
            return view.layoutMarginsGuide
        }
    }
    
    var btnAdd: UIBarButtonItem {
        let btn = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(presentAddVc))
        return btn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        setupViews()
        configureTableView()
        setupData()
        
        setupSearch()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupData), name: .onDeleteLocations, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            navItem.hidesSearchBarWhenScrolling = false
        }
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            navItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        navItem.rightBarButtonItem = btnAdd
        
        navBar.setItems([navItem], animated: false)
        
        view.addSubview(navBar)
        view.addSubview(tableView)
        view.addSubview(lblEmpty)
        
        NSLayoutConstraint.activate([navBar.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
                                     navBar.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
                                     navBar.topAnchor.constraint(equalTo: layoutGuide.topAnchor)])
        
        NSLayoutConstraint.activate(
            [lblEmpty.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
             lblEmpty.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
             lblEmpty.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 1)
        ])
        lblEmptyHeightConstraint = lblEmpty.heightAnchor.constraint(equalToConstant: 0)
        lblEmptyHeightConstraint.isActive = true
        
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        
        // Do not obsecure
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        }
        
        
        searchController.searchBar.placeholder = "Search Location"
        if #available(iOS 11.0, *) {
            navItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        definesPresentationContext = true
        
        self.searchController.extendedLayoutIncludesOpaqueBars = false
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        NSLayoutConstraint.activate(
            [tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
             tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 1),
             tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -43)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc private func presentAddVc() {
        searchController.isActive = false
        let vc = AddLocationViewController()
        vc.saveLocationDelegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func setupData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.databaseContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        do {
            locations.removeAll()
            filteredLocations.removeAll()
            locations = try managedContext.fetch(fetchRequest)
            filteredLocations.append(contentsOf: locations)
            tableView.reloadData()
            
            if locations.isEmpty {
                lblEmptyHeightConstraint.constant = 50
            } else {
                lblEmptyHeightConstraint.constant = 0
            }
        } catch let error as NSError {
            showAlert("Could not fetch saved locations")
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func filterAddress(_ searchText: String) {
        if !isSearchBarEmpty {
            filteredLocations = filterLocations(items: locations, searchTerm:  searchText)
            filteredLocations = locations.filter { (item: NSManagedObject) -> Bool in
                let address = item.value(forKey: "address") as! String
                return address.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
    
    func filterLocations(items: [NSManagedObject], searchTerm: String) -> [NSManagedObject] {
        return items.filter { (item: NSManagedObject) -> Bool in
            let address = item.value(forKey: "address") as! String
            return address.lowercased().contains(searchTerm.lowercased())
        }
    }
    
}

// MARK: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchBarEmpty {
            return locations.count
        } else {
            return filteredLocations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: NSManagedObject!
        if !self.isFiltering {
            item = self.locations[indexPath.row]
        } else {
            item = self.filteredLocations[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationCell
        cell.selectionStyle = .none
        let address = item.value(forKey: "address") as! String
        cell.lblAddress.text = address
        if isFiltering {
            if let searchTxt = searchText {
                let stringRange = address.lowercased().range(of: searchTxt.lowercased())
                if let range = stringRange {
                    let nsRange = NSRange(range, in: address.lowercased())
                    let attributedString = NSMutableAttributedString(string: address)
                    attributedString.setAttributes([NSAttributedString.Key.foregroundColor: cell.lblAddress.tintColor ?? UIColor.blue],
                                                   range: nsRange)
                    cell.lblAddress.attributedText = attributedString
                }
            }
        }
        return cell
    }
    
    
}

// MARK: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            var item: NSManagedObject!
            if !self.isFiltering {
                item = self.locations[indexPath.row]
            } else {
                item = self.filteredLocations[indexPath.row]
            }
            
            let vc = LocationDetailsViewController()
            vc.item = item
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .flipHorizontal
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if editingStyle == .delete {
                var item: NSManagedObject!
                if !self.isFiltering {
                    item = self.locations[indexPath.row]
                } else {
                    item = self.filteredLocations[indexPath.row]
                }
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                
                let managedContext = appDelegate.databaseContext
                managedContext.delete(item)
                
                do {
                    if self.searchController.searchBar.text?.isEmpty == true && self.searchController.isActive == false {
                        self.locations.remove(at: indexPath.row)
                    } else {
                        self.filteredLocations.remove(at: indexPath.row)
                        let idx = self.locations.firstIndex(where: { (ele) -> Bool in
                            ele.objectID == item.objectID
                        })
                                                                        
                        if let index = idx {
                            if index >= 0 {
                                self.locations.remove(at: index)
                            }
                        }
                    }
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                    try managedContext.save()
                } catch _ as NSError {
                    self.showAlert("Could not delete item")
                }
            
            }
        }
        
    }
}

// MARK: SaveLocationDelegate
extension HomeViewController: SaveLocationDelegate {
    func didSaveLocation() {
        self.setupData()
    }
    
}

//MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterAddress(searchBar.text!)
    }
}
