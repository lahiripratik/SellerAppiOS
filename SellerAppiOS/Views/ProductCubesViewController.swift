//
//  ProductCubeViewController.swift
//  SellerAppiOS
//
//  Created by Pratik Lahiri on 22/12/24.
//
import UIKit

class ProductCubesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    private let viewModel = ProductViewModel.shared // Use the shared instance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout

        self.collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let headerVC = segue.destination as? HeaderViewController {
            headerVC.delegate = self
        }
    }
    
    func updateSearchResults(query: String) {
        viewModel.searchProducts(query: query)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let product = viewModel.filteredProducts[indexPath.row]
        cell.itemLabel.text = product.name
        cell.itemPrice.text = "₹\(product.price ?? "0")"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = 5 * 3
        let width = (collectionView.frame.width - CGFloat(totalSpacing) - 10) / 3
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}

// MARK: - HeaderViewDelegate
extension ProductCubesViewController: HeaderViewDelegate {
    func didUpdateSearchText(_ searchText: String) {
        updateSearchResults(query: searchText)
    }
}
