//
//  ProfileViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 12/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// ProflieView is the interface where user can modify its settings
class ProfileViewController: UIViewController, ProfileView {
    var presenter: ProfileViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ProfilePresenter(view: self)
        
        if #available(iOS 13, *) {
            // With IOS 13, the segue is not fullscreen and can be dismissed with swipe
            dismissButton.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setAvatarDisplay()
    }
    
    // MARK: Properties
    private enum UpdateUserInfo {
        case username, email
    }
    
    private var userActions: [String] { // returns string array containing cell's reusable identifiers to use in order.
        if presenter.isConnectedAnonymously {
            return [CellType.attachEmail.rawValue, CellType.disconnect.rawValue]
        } else {
            return [CellType.changeAvatar.rawValue,
                    CellType.changeUsername.rawValue,
                    CellType.changeEmail.rawValue,
                    CellType.changePassword.rawValue,
                    CellType.disconnect.rawValue]
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    
    // MARK: Actions
    @IBAction func didTapDisconnectButton(_ sender: Any) { // presents alert and disconnects user
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
    
    @IBAction func changePseudo(_ sender: Any) { // changes pseudo
        prepareAlertForNew(.username) { pseudo, password  in
            self.presenter.updatePseudo(to: pseudo, with: password)
        }
    }
    
    @IBAction func changeEmail(_ sender: Any) { // changes email
        prepareAlertForNew(.email) { (email, password) in
            self.presenter.updateEmail(to: email, with: password)
        }
    }
    
    @IBAction func changePassword(_ sender: Any) { // changes password
        changePassword { (old, new, confirmation) in
            self.presenter.updatePassword(to: new, confirm: confirmation, with: old)
        }
    }
    
    @IBAction func changeAvatar(_ sender: Any) { // changes avatar
        importPicture()
    }
    
    // MARK: methods
    func display(username: String) { // displays username
        usernameLabel.text = username
    }
     
    func display(avatar: Data) { // displays avatar
        let avatar = UIImage(data: avatar)
        
        self.avatar.image = avatar
    }
    
    func display(email: String) { // displays email
        emailLabel.text = email
    }
    
    func userSignedOut() { // performs segue when user signed Out
        performSegue(withIdentifier: SegueType.launchUnwind.rawValue, sender: self)
    }
    
    func passwordChanged() { // presents alert confirming password is modified
        let alert = UIAlertController(title: "Succès !",
                                      message: "Votre mot de passe a été modifié avec succès !",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertStrings.ok.rawValue, style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentDeterDisconect(handler: @escaping (Bool) -> Void) { // presents deterAlert to prevent data loose
        let alertVC = UIAlertController(title: "Êtes-vous sûr ?",
                                        message: "Toutes vos données, telles que votre score, seront perdues (Vous pouvez vous inscrire pour les sauvegarder)", // swiftlint:disable:this line_length
            preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Se déconnecter",
                                        style: .destructive,
                                        handler: { _ in
                                            handler(true)
        }))
        
        alertVC.addAction(UIAlertAction(title: AlertStrings.cancel.rawValue,
                                        style: .cancel,
                                        handler: { _ in
                                            handler(false)
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // prepares alert to ask new userInfos
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
        
        alert.addAction(UIAlertAction(title: AlertStrings.ok.rawValue, style: .default, handler: { [weak alert] (_) in
            let changeId = alert?.textFields?[0].text
            let pass = alert?.textFields?[1].text
            completion(changeId, pass)
        }))
        
        alert.addAction(UIAlertAction(title: AlertStrings.cancel.rawValue, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // prepares alert with textfields to modify password
    private func changePassword(completion: @escaping (String?, String?, String?) -> Void) {
        let alert = UIAlertController(title: "Nouveau mot de passe :", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Mot de passe actuel"
            textField.keyboardType = .default
            textField.textContentType = .password
            textField.isSecureTextEntry = true
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nouveau mot de passe"
            textField.keyboardType = .default
            textField.textContentType = .password
            textField.isSecureTextEntry = true
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Confirmation du mot de passe"
            textField.keyboardType = .default
            textField.textContentType = .password
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: AlertStrings.ok.rawValue, style: .default, handler: { [weak alert] (_) in
            completion(alert?.textFields?[0].text, alert?.textFields?[1].text, alert?.textFields?[2].text)
        }))
        
        alert.addAction(UIAlertAction(title: AlertStrings.cancel.rawValue, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // asks password to validate action
    private func askPassword(completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "Mot de passe :", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Mot de passe"
            textField.keyboardType = .default
            textField.textContentType = .password
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: AlertStrings.ok.rawValue, style: .default, handler: { [weak alert] (_) in
            guard let text = alert?.textFields?.first?.text,
                text != "" else {
                    completion(nil)
                    return
            }
            
            completion(text)
        }))
        
        alert.addAction(UIAlertAction(title: AlertStrings.cancel.rawValue, style: .cancel, handler: { (_) in
            completion(nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // sets up avatar display
    private func setAvatarDisplay() {
        avatar.layer.cornerRadius = (avatar.frame.size.width) / 2
        avatar.clipsToBounds = true
    }
}

extension ProfileViewController: UITableViewDataSource { // manages table view
    
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

// manages imagePicker
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage,
            let data = image.jpegData(compressionQuality: 0) else { return }
        
        dismiss(animated: true) {
            self.askPassword { (password) in
                self.presenter.updateAvatar(to: data, with: password)
            }
        }
    }
}
