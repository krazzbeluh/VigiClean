//
//  MarketplaceViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 10/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import UIKit

class MarketplaceViewController: UIViewController, MarketplaceView {
    var presenter: MarketplaceViewPresenter!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = MarketplacePresenter(view: self)

        // Do any additional setup after loading the view.
    }

}

extension MarketplaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MarketplaceManager.sales.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketplaceCell",
                                                            for: indexPath) as? MarketplaceCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: MarketplaceManager.sales[indexPath.row])
        
        return cell
    }
}
