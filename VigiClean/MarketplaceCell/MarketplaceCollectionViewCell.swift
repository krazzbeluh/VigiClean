//
//  MarketplaceCollectionViewCell.swift
//  VigiClean
//
//  Created by Paul Leclerc on 10/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import UIKit
import Kingfisher

class MarketplaceCollectionViewCell: UICollectionViewCell, MarketplaceCellView {
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var presenter: MarketplaceCellViewPresenter!
    
    func configure(with sale: Sale) {
        presenter = MarketplaceCellPresenter(view: self, sale: sale)
        
        titleLabel.text = sale.title
        
        titleLabel.layer.cornerRadius = titleLabel.frame.height / 5
        titleLabel.layer.masksToBounds = true
        
        imageButton.kf.setImage(with: sale.image, for: .normal)
    }
    
    @IBAction func didSelectSale(_ sender: Any) {
        presenter.buySale()
    }
}
