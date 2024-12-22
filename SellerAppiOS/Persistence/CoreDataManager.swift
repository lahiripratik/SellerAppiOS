//
//  CoreDataManager.swift
//  SellerAppiOS
//
//  Created by Pratik Lahiri on 30/12/24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager() // Singleton instance
    
    // Persistent Container
    let persistentContainer: NSPersistentContainer
    
    // Managed Object Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        // Initialize the persistent container
        persistentContainer = NSPersistentContainer(name: "SellerAppModelData") // Replace with your .xcdatamodeld file name
        
        // Load persistent stores
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // Save Context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Fetch Products from Core Data
    func fetchProducts() -> [ProductEntity] {  // Change Product to ProductEntity
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()  // Use the correct entity name

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch products: \(error)")
            return []
        }
    }
    
    // Add Product to Core Data
    func addProduct(name: String, price: String, extra: String) {
        let context = persistentContainer.viewContext

        // Create a new ProductEntity object
        let product = ProductEntity(context: context) // Use ProductEntity

        // Assign properties to the new product
        product.name = name
        product.price = price
        product.extra = extra

        saveContext() // Save to Core Data
    }

    // Clear all Products in Core Data
    func clearAllProducts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProductEntity.fetchRequest() // Use ProductEntity
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error clearing products: \(error)")
        }
    }
    
    func searchProducts(query: String) -> [ProductEntity] {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        
        if query.isEmpty {
            return fetchProducts()  // Return all products if search text is empty
        }

        // Create the predicate for searching products by name or extra (case-insensitive search)
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR extra CONTAINS[cd] %@", query, query)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Error searching for products: \(error.localizedDescription)")
            return []  // Return empty array if there's an error
        }
    }
}
