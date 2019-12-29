//
//  RequestViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 26/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit
import MapKit

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
    @IBOutlet weak var employeeLabel: UILabel!
    @IBOutlet weak var switchMode: UISwitch!
    @IBOutlet weak var necessaryLabel: UILabel!
    @IBOutlet weak var validSwitch: UISwitch!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RequestPresenter(view: self)
        
        myPicker.delegate = self
        myPicker.dataSource = self
        action.inputView = myPicker
        
        presenter.fetchRole { isEmployee in
            self.employeeLabel.isHidden = !isEmployee
            self.switchMode.isHidden = !isEmployee
            self.switchMode.isOn = isEmployee
            self.switchChanged(mySwitch: self.switchMode)
            self.action.text = self.presenter.actions.first
            self.necessaryLabel.isHidden = !isEmployee
            self.validSwitch.isHidden = !isEmployee
        }
        
        switchMode.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        presenter.prepareMap()
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
        loading(grayed: false)
        performSegue(withIdentifier: "segueToCongrats", sender: self)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        presenter.switchEmployeeMode(to: value)
        action.text = presenter.actions.first
    }
    
    // MARK: Actions
    
    @IBAction func sendRequest(_ sender: Any) {
        loading(grayed: true)
        
        guard let action = action.text, action != "" else {
            sendAlert(message: presenter.convertError(ObjectManager.ObjectError.nilInTextField))
            return
        }
        
        presenter.sendRequest(with: action, isValid: validSwitch.isOn) { result in
            switch result {
            case .success(let employeeMode):
                if !employeeMode {
                    self.requestSent()
                }
            case .failure(let error):
                self.sendAlert(message: self.presenter.convertError(error))
            }
        }
    }
    
    @IBAction func dismissSelector(_ sender: Any) {
        action.resignFirstResponder()
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
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

// MARK: MapKit
extension RequestViewController: MKMapViewDelegate {
    func configureMap(with location: Poi) {
        let regionMeters: CLLocationDistance = 100
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: regionMeters,
                                        longitudinalMeters: regionMeters)
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
        mapView.addAnnotation(location)
    }
}
