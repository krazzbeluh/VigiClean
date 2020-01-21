//
//  SignUpViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 14/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// SignUpView is the interface where user can sign up
class SignUpViewController: UIViewController, SignUpView {
    // MARK: Properties
    var presenter: SignUpViewPresenter!
    
    // MARK: Outlets
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var performButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dismissButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SignUpPresenter(view: self)
        
        if #available(iOS 13, *) {
            // With IOS 13, the segue is not fullscreen and can be dismissed with swipe
            dismissButton.isHidden = true
        }
        
        if #available(iOS 12.0, *) {
            // Since IOS 12, a bug presents keyboard in qwerty
            textFields[2].textContentType = .oneTimeCode
            textFields[3].textContentType = .oneTimeCode
        }
    }
    
    // MARK: Actions
    @IBAction func didTapPerformButton(_ sender: Any) {
        signUp()
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
    func signUp() { // calls presenter method with user datas
        presenter.signUp(username: textFields[0].text,
                         email: textFields[1].text,
                         password: textFields[2].text,
                         confirmPassword: textFields[3].text)
    }
    
    func switchActivityIndicator(hidden: Bool) { // manages activityIndicator
        activityIndicator.isHidden = hidden
        performButton.isHidden = !hidden
    }
    
    // MARK: Segues
    func userSignedUp() { // Performs segue when userSignedUp
        performSegue(withIdentifier: SegueType.dashboard.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
}

// MARK: UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate { // Manages textfields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag < 3 {
            textFields[textField.tag + 1].becomeFirstResponder()
        } else {
            signUp()
        }
        return true
    }
}
