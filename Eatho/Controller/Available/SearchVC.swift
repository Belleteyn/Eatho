//
//  SearchVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class SearchVC: FoodVC {
    
    /**
     By initializing UISearchController with a nil value for the searchResultsController, you tell the search controller that you want use the same view you’re searching to display the results. If you specify a different view controller here, that will be used to display the results instead.
     */
    private var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTable.dataSource = self
        
        view.bindHeightToKeyboard()
        foodTable.bindHeightToKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startSpinner), name: NOTIF_SEARCH_FOOD_ADD, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addFinished(_:)), name: NOTIF_SEARCH_FOOD_ADD_DONE, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(releaseTextInput))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        configureSearch()
    }

    // Configure
    
    func configureSearch() {
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.searchTextField.backgroundColor = EATHO_VERY_LIGHT_PURPLE
        searchController.searchBar.searchTextField.textColor = TEXT_COLOR
        searchController.searchBar.barTintColor = EATHO_MAIN_COLOR
        searchController.searchBar.isHidden = false
        searchController.searchBar.sizeToFit()
        
        foodTable.tableHeaderView = searchController.searchBar
        
        if #available(iOS 11.0, *) {
        } else {
            searchController.dimsBackgroundDuringPresentation = false // The default is true.
        }
        
        /** Specify that this view controller determines how the search controller is presented.
            The search controller should be presented modally and match the physical size of this view controller.
        */
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController.isActive = true
        //searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.searchTextField.becomeFirstResponder()
    }
    
    // Handlers
    
    @objc func startSpinner() {
        spinner.startAnimating()
    }
    
    @objc func addFinished(_ notification: Notification) {
        spinner.stopAnimating()
        if let success = notification.userInfo?["success"] as? Bool {
            if success {
                close()
            }
        }
    }
    
    @objc func releaseTextInput() {
        searchController.searchBar.searchTextField.resignFirstResponder()
    }
    
    @objc func close() {
        searchController.isActive = false
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            SearchService.instance.reset()
            foodTable.reloadData()
        } else {
            spinner.startAnimating()
            SearchService.instance.requestSearch(searchArg: searchText) { (_, error) in
                
                self.spinner.stopAnimating()
                
                if let error = error {
                    self.showErrorAlert(title: ERROR_TITLE_SEARCH_FAILED, message: error.message)
                }
                
                self.foodTable.reloadData()
            }
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isSearching() -> Bool {
        return !searchBarIsEmpty() && searchController.isActive
    }
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchService.instance.foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "searchFoodCell") as? SearchFoodCell {
            if (indexPath.row < SearchService.instance.foods.count) {
                let food = SearchService.instance.foods[indexPath.row]
                cell.updateViews(food: food)
                return cell
            }
        }
        return SearchFoodCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let revealDetailsAction = UIContextualAction(style: UIContextualAction.Style.normal, title: DETAILS) { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.openDetails(food: SearchService.instance.foods[indexPath.row])
            success(true)
        }
        
        if #available(iOS 13.0, *) {
            revealDetailsAction.image = INFO_IMG
        }
        
        return UISwipeActionsConfiguration(actions: [revealDetailsAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openDetails(food: SearchService.instance.foods[indexPath.row])
    }
}
