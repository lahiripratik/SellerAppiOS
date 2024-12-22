//
//  HeaderViewController.swift
//  SellerAppiOS
//
//  Created by Pratik Lahiri on 29/12/24.
//

import UIKit
protocol HeaderViewDelegate {
    func didUpdateSearchText(_ text: String)
}

class HeaderViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate: HeaderViewDelegate?
    private let viewModel = ProductViewModel.shared // Use the shared instance

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.text = viewModel.searchText
        
        // Add tap gesture to dismiss the keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = viewModel.searchText // Ensure the search bar reflects the current searchText
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
        viewModel.searchProducts(query: searchText)  // Trigger search in CoreDataManager
        delegate?.didUpdateSearchText(searchText)  // Notify delegate (if needed)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.searchText = ""
        delegate?.didUpdateSearchText("")
    }

    // Close keyboard when tapping outside the search bar
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    // Dismiss the keyboard when the search button is pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
