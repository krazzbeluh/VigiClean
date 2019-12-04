//
//  RequestViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 26/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController, RequestView {
    var presenter: RequestViewPresenter!
    
    // MARK: Properties
    let myPicker = UIPickerView()
    
    // MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var grayOutView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var action: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RequestPresenter(view: self)
        
        myPicker.delegate = self
        myPicker.dataSource = self
        action.inputView = myPicker
    }
    
    // MARK: Methods
    func loading(grayed: Bool) {
        activityIndicator.isHidden = !grayed
        grayOutView.isHidden = !grayed
    }
    
    func configure(with object: Object) {
        nameLabel.text = object.name
        organizationLabel.text = object.organization
        typeLabel.text = object.type
    }
    
    func requestSent() {
        print("OK")
    }
    
    // MARK: Actions
    
    @IBAction func sendRequest(_ sender: Any) {
        guard let action = action.text else {
            showAlert(with: UserAccount.UAccountError.emptyTextField) // TODO: use correct error
            return
        }
        
        presenter.sendRequest(with: action)
    }
    
}

extension RequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.actions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter.actions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        action.text = presenter.actions[row]
    }
}
