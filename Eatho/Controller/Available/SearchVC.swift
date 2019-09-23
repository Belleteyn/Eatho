//
//  SearchVC.swift
//  Eatho
//
//  Created by Серафима Зыкова on 19/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

class SearchVC: FoodVC {
    
    /*
     By initializing UISearchController with a nil value for the searchResultsController, you tell the search controller that you want use the same view you’re searching to display the results. If you specify a different view controller here, that will be used to display the results instead.
     */
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTable.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(startSpinner), name: NOTIF_SEARCH_FOOD_ADD, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addFinished(_:)), name: NOTIF_SEARCH_FOOD_ADD_DONE, object: nil)
        configureSearch()
    }

    // Configure
    
    func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        //searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.barStyle = .default
        searchController.searchBar.placeholder = "Search food"
        searchController.searchBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchController.searchBar.isHidden = false
        
        navigationItem.largeTitleDisplayMode = .never
        
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: TEXT_COLOR]
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search food", attributes: [NSAttributedString.Key.foregroundColor: TEXT_COLOR])
        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            if let backgroundview = textfield.subviews.first {

                // Background color
                backgroundview.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5482930223)

                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }

        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.isActive = true
    }
    
    override func openDetails(index: Int) {
        guard let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC else { return }
        
        present(detailsVC, animated: true, completion: nil)
        detailsVC.initData(food: SearchService.instance.foods[index])
    }
    
    // Handlers
    
    @objc func startSpinner() {
        spinner.startAnimating()
    }
    
    @objc func addFinished(_ notification: Notification) {
        spinner.stopAnimating()
        if let success = notification.userInfo?["success"] as? Bool {
            if success {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            SearchService.instance.clearData()
            foodTable.reloadData()
        } else {
            spinner.startAnimating()
            SearchService.instance.requestSearch(searchArg: searchText) { (success, error) in
                
                self.spinner.stopAnimating()
                
                if let error = error {
                    self.showErrorAlert(title: ERROR_TITLE_SEARCH_FAILED, message: error.localizedDescription)
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
        
        let revealDetailsAction = UIContextualAction(style: UIContextualAction.Style.normal, title: "Details") { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.openDetails(index: indexPath.row)
            success(true)
        }
        
        return UISwipeActionsConfiguration(actions: [revealDetailsAction])
    }
}
