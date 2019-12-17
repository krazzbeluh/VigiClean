//
//  ProfileViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 12/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// TODO: add avatar
// TODO: change username

class ProfileViewController: UIViewController, ProfileView {
    var presenter: ProfileViewPresenter!
    
    let accountManager = AccountManager() // TODO: move to mvp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ProfilePresenter(view: self)
    }
    // MARK: Actions
    @IBAction func didTapDisconnectButton(_ sender: Any) {
        if presenter.isConnectedAnonymously {
            presentDeterDisconect { canDisconnect in
                guard canDisconnect == true else {
                    return
                }
                
                self.launchSignOutRequest()
            }
        } else {
            launchSignOutRequest()
        }
    }
    
    private func presentDeterDisconect(handler: @escaping (Bool) -> Void) {
        let alertVC = UIAlertController(title: "Êtes-vous sûr ?",
                                        message: "Toutes vos données, telles que votre score, seront perdues (Vous pouvez vous inscrire pour les sauvegarder)",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Se déconnecter",
                                        style: .destructive,
                                        handler: { _ in
                                            handler(true)
        }))
        
        alertVC.addAction(UIAlertAction(title: "Annuler",
                                        style: .cancel,
                                        handler: { _ in
                                            handler(false)
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func launchSignOutRequest() {
        self.accountManager.signOut { error in
            if let error = error {
                self.sendAlert(message: self.presenter.convertAlert(with: error))
            } else {
                self.performSegue(withIdentifier: "unwindToLaunch", sender: self)
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Paramètres"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountManager.isConnectedWithEmail ? 3 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "DisconnectCell", for: indexPath)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "AttachEmailCell", for: indexPath)
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "changeAvatarCell", for: indexPath)
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "changeUsernameCell", for: indexPath)
        default:
            cell = UITableViewCell()
        }
        
        return cell
    }
}
