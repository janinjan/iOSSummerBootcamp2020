//
//  SandwichViewController.swift
//  SandwichSaturation
//
//  Created by Jeff Rames on 7/3/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit

protocol SandwichDataSource {
    func saveSandwich(_: SandwichData)
}

class SandwichViewController: UITableViewController, SandwichDataSource {
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    var sandwiches = [SandwichData]()
    var filteredSandwiches = [SandwichData]()
    let userDefaults = UserDefaults.standard // Create a global instance of UserDefaults class

    let segueToAddSandwichIdentifier = "AddSandwichSegue"
    let tableViewSandwichCellIdentifier = "sandwichCell"
    let searchBarPlaceHolderText = "Filter Sandwiches"

    // MARK: Inits
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadSandwiches()
    }

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setupBarButtonItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                        action: #selector(presentAddView(_:)))
        navigationItem.rightBarButtonItem = addButton
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = searchBarPlaceHolderText
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = SauceAmount.allCases.map { $0.rawValue }
        searchController.searchBar.selectedScopeButtonIndex = userDefaults.lastScopeSelection // Display last scope selection
        searchController.searchBar.delegate = self
    }

    private func loadSandwiches() {
        guard let sandwichesURL = Bundle.main.url(forResource: "sandwiches", withExtension: "json") else { return }

        let decoder = JSONDecoder()
        do {
            let sandwichData = try Data(contentsOf: sandwichesURL)
            let sandwich = try decoder.decode([SandwichData].self, from: sandwichData)
            sandwiches.append(contentsOf: sandwich)
        } catch let error {
            print(error)
        }
    }

    func saveSandwich(_ sandwich: SandwichData) {
        sandwiches.append(sandwich)
        tableView.reloadData()
    }

    @objc
    func presentAddView(_ sender: Any) {
        performSegue(withIdentifier: segueToAddSandwichIdentifier, sender: self)
    }

    // MARK: - Search Controller
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String, sauceAmount: SauceAmount? = nil) {
        filteredSandwiches = sandwiches.filter { (sandwhich: SandwichData) -> Bool in
            let doesSauceAmountMatch = sauceAmount == .any || sandwhich.sauceAmount == sauceAmount
            
            if isSearchBarEmpty {
                return doesSauceAmountMatch
            } else {
                return doesSauceAmountMatch && sandwhich.name.lowercased()
                    .contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0

        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredSandwiches.count : sandwiches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewSandwichCellIdentifier, for: indexPath) as? SandwichCell
        else { return UITableViewCell() }

        let sandwich = isFiltering ? filteredSandwiches[indexPath.row] : sandwiches[indexPath.row]

        cell.thumbnail.image = UIImage.init(imageLiteralResourceName: sandwich.imageName)
        cell.nameLabel.text = sandwich.name
        cell.sauceLabel.text = sandwich.sauceAmount.description

        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension SandwichViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let sauceAmount = SauceAmount(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])

        filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
    }
}

// MARK: - UISearchBarDelegate
extension SandwichViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        userDefaults.lastScopeSelection = selectedScope // Updates the value of selected scope in UserDefaults

        let sauceAmount = SauceAmount(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, sauceAmount: sauceAmount)
    }
}
