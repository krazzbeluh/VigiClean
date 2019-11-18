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
            guard error == nil else {
                print(error!) // TODO : display error
                return
            }
            performSegue(withIdentifier: "unwindToWelcome", sender: self)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: UserAccount.isConnectedWithEmail ? "DisconnectCell" : "ConnectionCell",
            for: indexPath)
        
        return cell
    }
}
