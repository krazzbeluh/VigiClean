//
//  AttachEmailViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 25/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// AttachEmailView is similar to SignUp, it lets user convert anonymous account to email
class AttachEmailViewController: UIViewController, AttachEmailView {
    // MARK: Properties
    var presenter: AttachEmailViewPresenter!
    
    // MARK: Outlets
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var performButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AttachEmailPresenter(view: self)
        
        if #available(iOS 13, *) {
            dismissButton.isHidden = true
        }
        
        if #available(iOS 12, *) {
            textFields[2].textContentType = .oneTimeCode
            textFields[3].textContentType = .oneTimeCode
        }
    }
    
    // MARK: Actions
    @IBAction func didTapPerformButton(_ sender: Any) {
        attachEmail()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        for textField in textFields {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func didTapDismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Methods
    func attachEmail() { // Calls presenter method
        presenter.attachEmail(username: textFields[0].text,
                              email: textFields[1].text,
                              password: textFields[2].text,
                              confirmPassword: textFields[3].text)
    }
    
    func updatedPseudo() { // performs segue on pseudo modification
        performSegue(withIdentifier: SegueType.launchUnwind.rawValue, sender: self)
    }
    
    func switchActivityIndicator(hidden: Bool) { // manages activityIndicator
        activityIndicator.isHidden = hidden
        performButton.isHidden = !hidden
    }
    
    func attachedEmail() { // calls updatePseudo when email attached
        presenter.updatePseudo(username: textFields[0].text,
                               password: textFields[2].text,
                               confirmPassword: textFields[3].text)
    }
}

// MARK: UITextFieldDelegate
extension AttachEmailViewController: UITextFieldDelegate { // manages textFields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag < 3 {
            textFields[textField.tag + 1].becomeFirstResponder()
        } else {
            attachEmail()
        }
        return true
    }
}
