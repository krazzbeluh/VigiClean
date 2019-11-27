//
//  ProfileViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 12/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

protocol ProfileView: class {
}

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    // MARK: Actions
    @IBAction func didTapDisconnectButton(_ sender: Any) {
        UserAccount.signOut { error in
            if let error = error {
                showAlert(with: error)
            } else {
                performSegue(withIdentifier: "unwindToLaunch", sender: self)
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Compte"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserAccount.isConnectedWithEmail ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "DisconnectCell", for: indexPath)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionCell", for: indexPath)
        default:
            cell = UITableViewCell()
        } // TODO: make connectionCell attachEmailCell
        
        return cell
    }
}
