//
//  SandwichViewController.swift
//  SandwichSaturation
//
//  Created by Jeff Rames on 7/3/20.
//  Copyright © 2020 Jeff Rames. All rights reserved.
//

import UIKit
import CoreData

protocol SandwichDataSource {
    func saveSandwich(_: SandwichData)
}

class SandwichViewController: UITableViewController, SandwichDataSource {
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedRC: NSFetchedResultsController<Sandwich>!

    var sandwiches = [Sandwich]()
    var filteredSandwiches = [Sandwich]()

    let userDefaults = UserDefaults.standard // Create a global instance of UserDefaults class

    let segueToAddSandwichIdentifier = "AddSandwichSegue"
    let tableViewSandwichCellIdentifier = "sandwichCell"
    let searchBarPlaceHolderText = "Filter Sandwiches"

    // MARK: Inits
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
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
            let sandwiches = try decoder.decode([SandwichData].self, from: sandwichData)
            for sandwich in sandwiches {
                saveSandwich(sandwich) // Save each sandwich in Core Data
            }
            refresh()
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    private func refresh() {
        let request = Sandwich.fetchRequest() as NSFetchRequest<Sandwich>
        let sort = NSSortDescriptor(key: #keyPath(Sandwich.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
            if let objects = fetchedRC.fetchedObjects {
                if objects.isEmpty {
                    loadSandwiches() // load sandwiches from json and save them
                } else {
                    sandwiches = objects // fill the sandwiches' array with objects fetched from Core Data
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    private func sandwichesFetchRequest(with compoundPredicate: NSPredicate) {
        let request = Sandwich.fetchRequest() as NSFetchRequest<Sandwich>
        request.predicate = compoundPredicate
        let sort = NSSortDescriptor(key: #keyPath(Sandwich.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
            if let objects = fetchedRC.fetchedObjects {
                filteredSandwiches = objects
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func saveSandwich(_ sandwich: SandwichData) {
        let sandwichToSave = Sandwich(entity: Sandwich.entity(),
                                      insertInto: context)
        let sauceAmountModel = SauceAmountModel(entity: SauceAmountModel.entity(),
                                                insertInto: context)

        sauceAmountModel.sauceAmount = sandwich.sauceAmount
        sandwichToSave.name = sandwich.name
        sandwichToSave.imageName = sandwich.imageName
        sandwichToSave.sauce = sauceAmountModel
        appDelegate.saveContext()
        refresh()
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
        guard let sauceAmount = sauceAmount else { return }
        let nonePredicate =  NSPredicate(format: "sauce.amount = %@", SauceAmount.none.rawValue)
        let tooMuchPredicate = NSPredicate(format: "sauce.amount = %@", SauceAmount.tooMuch.rawValue)
        let searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        let sauceAmountPredicate: NSPredicate
        let compoundPredicate: NSPredicate

        switch sauceAmount {
        case .any:
            sauceAmountPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                nonePredicate,
                tooMuchPredicate
            ])
        case .none:
            sauceAmountPredicate = nonePredicate
        case .tooMuch:
            sauceAmountPredicate = tooMuchPredicate
        }

        if searchText.isEmpty {
            compoundPredicate = sauceAmountPredicate // sauce.amount == "None" OR sauce.amount == "Too Much"
        } else {
            compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [
                searchPredicate,
                sauceAmountPredicate
            ])
        }
        sandwichesFetchRequest(with: compoundPredicate)
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

        cell.thumbnail.image = UIImage(named: sandwich.imageName)
        cell.nameLabel.text = sandwich.name
        cell.sauceLabel.text = sandwich.sauce.amount

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sandwich = self.fetchedRC.object(at: indexPath)
            self.sandwiches.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.context.delete(sandwich)
            self.appDelegate.saveContext()
            self.refresh()
        }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if searchController.isActive { // Delete is not possible when the search is active
            return .none
        }
        return .delete
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
