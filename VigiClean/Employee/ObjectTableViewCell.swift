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
    
    private var object: Object!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(for object: Object) {
        self.object = object
        nameLabel.text = object.name
        typeLabel.text = object.type
        organizationLabel.text = object.organization
        
        let poi = Poi(title: object.name,
                      coordinate: CLLocationCoordinate2D(latitude: object.coords.latitude,
                                                         longitude: object.coords.longitude),
                      info: object.type)
        
        configureMap(with: poi)
    }
    
    @IBAction func didTapGoTo(_ sender: Any) {
        openMapForPlace()
    }
    
    func openMapForPlace() {
        
        let latitude: CLLocationDegrees = object.coords.latitude
        let longitude: CLLocationDegrees = object.coords.longitude
        
        let regionDistance: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates,
                                            latitudinalMeters: regionDistance,
                                            longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(object.name) - \(object.organization)"
        mapItem.openInMaps(launchOptions: options)
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
