//
//  Product.swift
//  SellerAppiOS
//
//  Created by Pratik Lahiri on 22/12/24.
//

import Foundation

class ProductService {
    static let shared = ProductService() // Singleton instance
    
    func fetchProductsFromAPI(completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://run.mocky.io/v3/0d3f5911-1041-411b-ae9b-df0113e6a02c") else {
            completion(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(error)
                return
            }

            do {
                // Decode API response
                let response = try JSONDecoder().decode(Response.self, from: data)
                let products = response.data.items
                
                // Save each product to Core Data
                products.forEach { product in
                    CoreDataManager.shared.addProduct(
                        name: product.name,
                        price: product.price,
                        extra: product.extra
                    )
                }
                completion(nil)
            } catch {
                completion(error)
            }
        }.resume()
    }
}

// Models for decoding the JSON response
struct Response: Codable {
    let status: String
    let data: DataWrapper
}

struct DataWrapper: Codable {
    let items: [Product]
}
