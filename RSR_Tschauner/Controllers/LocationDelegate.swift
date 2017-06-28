//
//  LocationDelegate.swift
//  RSR
//
//  Created by Philipp Tschauner on 28.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import CoreLocation
import UIKit
import MapKit



extension MapViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegion(center: userLocation, span: span)
        
        //set region on the map
        mapView.setRegion(region, animated: true)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            //print each key value pair
            //            addressDict.forEach { print($0) }
            
            // Access each element manually
            guard let street = addressDict["Thoroughfare"] as? String else { return }
            guard let number = addressDict["SubThoroughfare"] as? String else { return }
            guard let zip = addressDict["ZIP"] as? String else { return }
            guard let city = addressDict["City"] as? String else { return }
            
            self.userAddress = "\(street) \(number),\n\(zip), \(city)"
            
            // stop locating user (map stops moving)
            self.locationManager?.stopUpdatingLocation()
            
        })
        
        //pin coordinate on map
        pin.coordinate = userLocation
        
        //add pin to map
        mapView.addAnnotation(pin)
        
    }
    
}



