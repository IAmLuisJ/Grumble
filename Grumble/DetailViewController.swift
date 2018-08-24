//
//  DetailViewController.swift
//  Grumble
//
//  Created by Luis on 7/31/18.
//  Copyright © 2018 SkyCloud. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailViewController : UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedLocation : LocationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //create cordinates from location latitude and longitude
        var pointCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        pointCoordinates.latitude = CDouble(self.selectedLocation!.latitude!)!
        pointCoordinates.longitude = CDouble(self.selectedLocation!.longitude!)!
        
        //zoom to the region
        let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(pointCoordinates, 750, 750)
        self.mapView.setRegion(viewRegion, animated: true)
        // plot the destination pin
        let pin: MKPointAnnotation = MKPointAnnotation()
        pin.coordinate = pointCoordinates
        self.mapView.addAnnotation(pin)
        //add title to the pin
        pin.title = selectedLocation!.foodName
    }
}
