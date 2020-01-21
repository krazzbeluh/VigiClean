//
//  SaleTableViewCell.swift
//  VigiClean
//
//  Created by Paul Leclerc on 15/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import UIKit
import Kingfisher

// Sale Cell exemple in Sale list (Wallet)
class SaleTableViewCell: UITableViewCell {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    func configure(with sale: Sale) {
        partnerLabel.text = sale.partner
        codeLabel.text = sale.code
        logo.kf.setImage(with: sale.image)
    }

}
