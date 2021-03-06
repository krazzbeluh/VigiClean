//
//  WalletViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 15/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import UIKit

// WalletView presents every bought promotionnal offers to user
class WalletViewController: UIViewController, WalletView {
    var presenter: WalletViewPresenter!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var copyLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = WalletPresenter(view: self)
        presenter.getUserSales()
        
        if #available(iOS 13, *) {
            // With IOS 13, the segue is not fullscreen and can be dismissed with swipe
            dismissButton.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Displays logo rounded
        copyLabel.layer.cornerRadius = copyLabel.frame.height / 5
        copyLabel.layer.masksToBounds = true
    }

    @IBAction func didTaoDismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func gottenResponse() { // reloads data on response
        tableView.reloadData()
    }
}

extension WalletViewController: UITableViewDataSource { // manages tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.sales.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.saleCell.rawValue,
                                                       for: indexPath) as? SaleTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: presenter.sales[indexPath.row])
         
        return cell
    }
}

extension WalletViewController: UITableViewDelegate { // manages tableView actions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sale = presenter.sales[indexPath.row]
        
        UIPasteboard.general.string = sale.code
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.copyLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut, animations: {
                self.copyLabel.alpha = 0
            })
        })
    }
}
