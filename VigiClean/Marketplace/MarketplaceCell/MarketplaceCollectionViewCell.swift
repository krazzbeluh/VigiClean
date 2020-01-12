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
    weak var delegate: MarketplaceDelegate?
    
    func configure(with sale: Sale, delegate: MarketplaceDelegate) {
        presenter = MarketplaceCellPresenter(view: self, sale: sale)
        self.delegate = delegate
        
        titleLabel.text = sale.title
        
        titleLabel.layer.cornerRadius = titleLabel.frame.height / 5
        titleLabel.layer.masksToBounds = true
        
        imageButton.kf.setImage(with: sale.image, for: .normal)
    }
    
    @IBAction func didSelectSale(_ sender: Any) {
        presenter.buySale()
    }
    
    func sendAlert(with message: String) {
        delegate?.displayError(message: message)
    }
    
    func saleGotten(with code: String) {
        let alertVC = UIAlertController(
            title: "Votre récompense :",
            message: "Voici votre code promotionnel à utiliser chez notre partenaire : \n\(code)",
            preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: AlertStrings.ok.rawValue, style: .default, handler: nil))
        alertVC.addAction(UIAlertAction(title: AlertStrings.copy.rawValue, style: .default, handler: { (_) in
            UIPasteboard.general.string = code
        }))
        
        self.delegate?.present(alert: alertVC)
    }
}
