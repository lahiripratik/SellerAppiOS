//
//  ProductViewModel.swift
//  SellerAppiOS
//
//  Created by Pratik Lahiri on 22/12/24.
//
import Foundation

class ProductViewModel {
    // Singleton instance
    static let shared = ProductViewModel()

    // Private initializer to prevent creating multiple instances
    private init() {}

    // Core Data-backed properties
    private var allProducts: [ProductEntity] = []
    var filteredProducts: [ProductEntity] = []
    var searchText: String = ""

    // Fetch products from Core Data
    func fetchProducts(completion: @escaping () -> Void) {
        allProducts = CoreDataManager.shared.fetchProducts()

        // If Core Data is empty, fetch from API and save to Core Data
        if allProducts.isEmpty {
            ProductService.shared.fetchProductsFromAPI { error in
                if error == nil {
                    // Fetch products again after API call
                    print("Fetched from API Call")
                    self.allProducts = CoreDataManager.shared.fetchProducts()
                    self.filteredProducts = self.allProducts
                } else {
                    print("Failed to fetch products from API: \(String(describing: error))")
                }
                completion()
            }
        } else {
            // If products exist in Core Data, use them
            print("Fetched from core data")
            filteredProducts = allProducts
            completion()
        }
    }


    // Search products based on the query
    func searchProducts(query: String) {
        filteredProducts = CoreDataManager.shared.searchProducts(query: query)
    }
}
