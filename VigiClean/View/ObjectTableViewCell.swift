//
//  ObjectTableViewCell.swift
//  VigiClean
//
//  Created by Paul Leclerc on 08/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

class ObjectTableViewCell: UITableViewCell {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(for object: Object) {
        nameLabel.text = object.name
        typeLabel.text = object.type
        organizationLabel.text = object.organization
        
        let poi = Poi(title: "\(object.name)",
            coordinate: CLLocationCoordinate2D(latitude: object.coords.latitude,
                                               longitude: object.coords.longitude),
            info: object.type)
        
        configureMap(with: poi)
    }
    
    @IBAction func didTapGoTo(_ sender: Any) {
    }
}

extension ObjectTableViewCell: MKMapViewDelegate {
    private func configureMap(with location: Poi) {
        let regionMeters: CLLocationDistance = 100
        
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: regionMeters,
                                        longitudinalMeters: regionMeters)
        
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
        mapView.addAnnotation(location)
    }
}
