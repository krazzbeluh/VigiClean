//
//  ProfileViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 12/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// TODO: add avatar
// TODO: change password

class ProfileViewController: UIViewController, ProfileView {
    var presenter: ProfileViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ProfilePresenter(view: self)
    }
    
    // MARK: Properties
    private enum UpdateUserInfo {
        case username, email
    }
    
    private var userActions: [String] {
        if presenter.isConnectedAnonymously {
            return ["AttachEmailCell", "DisconnectCell"]
        } else {
            return ["changeAvatarCell", "changeUsernameCell", "changeEmailCell", "DisconnectCell"]
        }
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
        prepareAlertForNew(.username) { pseudo, password  in
            self.presenter.updatePseudo(to: pseudo, with: password)
        }
    }
    
    @IBAction func changeEmail(_ sender: Any) {
        prepareAlertForNew(.email) { (email, password) in
            self.presenter.updateEmail(to: email, with: password)
        }
    }
    
    // MARK: methods
    func display(username: String) {
        usernameLabel.text = username
    }
    
    func display(email: String) {
        emailLabel.text = email
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
    
    private func prepareAlertForNew(_ userInfo: UpdateUserInfo, completion: @escaping (String?, String?) -> Void) {
        let title: String
        
        switch userInfo {
        case .username:
            title = "Nouveau pseudo:"
        case .email:
            title = "Nouvelle adresse email :"
        }
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = userInfo == .username ? "Nouveau pseudo" : "Nouvelle adresse email"
            textField.keyboardType = userInfo == .username ? .default : .emailAddress
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Mot de passe"
            textField.textContentType = .password
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let changeId = alert?.textFields?[0].text
            let pass = alert?.textFields?[1].text
            completion(changeId, pass)
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
        return userActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: userActions[indexPath.row], for: indexPath)
    }
}
