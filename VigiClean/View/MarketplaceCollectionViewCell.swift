//
//  MarketplaceCollectionViewCell.swift
//  VigiClean
//
//  Created by Paul Leclerc on 10/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import UIKit
import Kingfisher

class MarketplaceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with sale: Sale) {
        titleLabel.text = sale.title
        
        image.kf.setImage(with: sale.image)
    }
}
