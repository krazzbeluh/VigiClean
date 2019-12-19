//
//  ProfileViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 12/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// TODO: add avatar
// TODO: change email

class ProfileViewController: UIViewController, ProfileView {
    var presenter: ProfileViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ProfilePresenter(view: self)
    }
    
    // MARK: Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: Actions
    @IBAction func didTapDisconnectButton(_ sender: Any) {
        if presenter.isConnectedAnonymously {
            presentDeterDisconect { canDisconnect in
                guard canDisconnect == true else {
                    return
                }
                
                self.presenter.signOut()
            }
        } else {
            presenter.signOut()
        }
    }
    
    @IBAction func changePseudo(_ sender: Any) {
        prepareAlertForNewPseudo { (text) in
            self.presenter.updatePseudo(to: text)
        }
    }
    
    // MARK: methods
    func display(username: String) {
        usernameLabel.text = username
    }
    
    func userSignedOut() {
        performSegue(withIdentifier: "unwindToLaunch", sender: self)
    }
    
    private func presentDeterDisconect(handler: @escaping (Bool) -> Void) {
        let alertVC = UIAlertController(title: "Êtes-vous sûr ?",
                                        message: "Toutes vos données, telles que votre score, seront perdues (Vous pouvez vous inscrire pour les sauvegarder)", // swiftlint:disable:this line_length
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
    
    private func prepareAlertForNewPseudo(completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "Nouveau pseudo :", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Pseudo"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let text = alert?.textFields![0].text // Force unwrapping because we know it exists.
            completion(text)
        }))
        
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
        return !presenter.isConnectedAnonymously ? 3 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells: [String]
        if presenter.isConnectedAnonymously {
            cells = ["AttachEmailCell", "changeAvatarCell", "changeUsernameCell", "DisconnectCell"]
        } else {
            cells = ["changeAvatarCell", "changeUsernameCell", "DisconnectCell"]
        }
        
        return tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row], for: indexPath)
    }
}
