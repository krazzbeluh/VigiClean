//
//  MarketplaceViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 10/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import UIKit

// MarketplaceView displays every promotional offers
class MarketplaceViewController: UIViewController, MarketplaceView {
    var presenter: MarketplaceViewPresenter!
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = MarketplacePresenter(view: self)
        
        presenter.getScore()
    }
    
    func setScoreLabel(to text: String) { // displays score
        score.text = text
    }
    
}

// mangages collectionView
extension MarketplaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MarketplaceManager.sales.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.marketPlace.rawValue,
                                                            for: indexPath) as? MarketplaceCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        
        cell.configure(with: MarketplaceManager.sales[indexPath.row], delegate: self)
        
        return cell
    }
}

//  manages colectionView display
extension MarketplaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension MarketplaceViewController: MarketplaceDelegate {
    func present(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}
