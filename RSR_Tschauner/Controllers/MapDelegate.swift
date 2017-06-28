//
//  MapDelegate.swift
//  RSR
//
//  Created by Philipp Tschauner on 28.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import MapKit
import UIKit


extension MapViewController: MKMapViewDelegate {
    
    // sets up the view for annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationIdentifier = "Identifier"
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        if let annotationView = annotationView {
            
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "address_back")
            
            // puts the annotation in the right place
            annotationView.centerOffset = CGPoint(x: 0, y: -100)
            
            // center = view.width/2 - (half width of label)
            let center = annotationView.frame.width/2
            
            let headline = UILabel()
            headline.textAlignment = .center
            headline.font = UIFont.boldSystemFont(ofSize: 18)
            headline.frame = CGRect(x: center - 75, y: 20, width: 150, height: 20)
            headline.text = "Uw locatie:"
            headline.textColor = .white
            
            let infoText = UILabel()
            infoText.textAlignment = .center
            infoText.font = UIFont.systemFont(ofSize: 14)
            infoText.text = "Onthoud deze locatie voor het telefoongesprek"
            infoText.numberOfLines = 0
            infoText.textColor = .white
            infoText.lineBreakMode = .byWordWrapping
            infoText.frame = CGRect(x: center - 100, y: annotationView.frame.height - 130, width: 200, height: 40)
            
            addressLabel.frame = CGRect(x: center - 90, y: 50, width: 180, height: 60)
            
            annotationView.addSubview(headline)
            annotationView.addSubview(addressLabel)
            annotationView.addSubview(infoText)
            
        }
        
        return annotationView
    }
    
}

