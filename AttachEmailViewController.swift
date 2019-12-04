//
//  AttachEmailViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 25/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

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
    
    // MARK: Methods
    func attachEmail() {
        presenter.attachEmail(username: textFields[0].text,
                         email: textFields[1].text,
                         password: textFields[2].text,
                         confirmPassword: textFields[3].text)
    }
    
    func emailAttached() {
        performSegue(withIdentifier: "unwindToLaunch", sender: self)
    }
    
    func switchActivityIndicator(hidden: Bool) {
        activityIndicator.isHidden = hidden
        performButton.isHidden = !hidden
    }
    
}

// MARK: UITextFieldDelegate
extension AttachEmailViewController: UITextFieldDelegate {
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
