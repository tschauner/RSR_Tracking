//
//  MapViewcontroller.swift
//  RSR_Tschauner
//
//  Created by Philipp Tschauner on 20.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var pin = MKPointAnnotation()
    let geoCoder = CLGeocoder()
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarTitle()
        
        setupViews()
        
        initLocationManger()
        
    
        
    }
    
    // ------ views -------
    
    let callButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitle("   Bel RSR nu", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: "btn_pressed"), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Annulieren", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "annuleren_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: "annuleren_pressed"), for: .highlighted)
        button.addTarget(self, action: #selector(cancelCall), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.alpha = 0
        return button
    }()
    
    var secondCallButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitle("Bel nu", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: "btn_pressed"), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.addTarget(self, action: #selector(callEmergency), for: .touchUpInside)
        return button
    }()
    
    var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.isUserInteractionEnabled = false
        return map
    }()
    
    var popup: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "popup_back")
        view.alpha = 0
        return view
    }()
    
    var addressView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "address_back")
        view.alpha = 0
        return view
    }()
    
    
    // ----- functions -------
    
    
    // initializes location manger
    func initLocationManger() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                showAlert(title: "GPS aanzetten", contentText: "U heeft deze app geen toegang gegeven voor GPS. Zet dit a.u.b. aan in uw instellingen.", actions: [action])
            case .authorizedAlways, .authorizedWhenInUse:
                animateView()
            }
        } else {
            print("Location services are not enabled")
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        DispatchQueue.main.async {
            self.locationManager?.startUpdatingLocation()
        }
    }
    // setup nav bar title
    func setupNavBarTitle() {
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = .white
        title.text = "RSR Pechulp"
        title.sizeToFit()
        
        navigationItem.titleView = title
        
    }
    
    
    // cancel call (popup fades out, shoes rest)
    @objc func cancelCall() {
        
        UIView.animate(withDuration: 0.3) {
            self.popup.alpha = 0
            self.cancelButton.alpha = 0
            self.secondCallButton.alpha = 0
        }
        
        callButton.isHidden = false
        addressView.isHidden = false
    }
    
    
    // setup views for pop up (popup fades in, hides rest)
    @objc func showPopup() {
        
        UIView.animate(withDuration: 0.3) {
            self.popup.alpha = 1
            self.cancelButton.alpha = 1
            self.secondCallButton.alpha = 1
        }
        
        callButton.isHidden = true
        addressView.isHidden = true
        
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ic_call")
        
        let headline = UILabel()
        headline.translatesAutoresizingMaskIntoConstraints = false
        headline.font = UIFont.boldSystemFont(ofSize: 18)
        headline.textColor = .white
        headline.text = "Belkosten"
        
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 18)
        text.textColor = .white
        text.numberOfLines = 0
        text.textAlignment = .center
        text.text = "Voor dit nummer betaalt u uw\n gebruikelike belkosten."
        
        // add views to subview
        view.addSubview(popup)
        view.addSubview(cancelButton)
        popup.addSubview(headline)
        popup.addSubview(text)
        view.addSubview(secondCallButton)
        secondCallButton.addSubview(image)
        
        // setup constraints
        popup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popup.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popup.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        popup.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        cancelButton.bottomAnchor.constraint(equalTo: popup.topAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: popup.leftAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        headline.topAnchor.constraint(equalTo: popup.topAnchor, constant: 20).isActive = true
        headline.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        
        text.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 30).isActive = true
        text.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        
        secondCallButton.bottomAnchor.constraint(equalTo: popup.bottomAnchor, constant: -30).isActive = true
        secondCallButton.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        secondCallButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        secondCallButton.widthAnchor.constraint(equalTo: popup.widthAnchor, constant: -70).isActive = true
        
        image.centerYAnchor.constraint(equalTo: secondCallButton.centerYAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: secondCallButton.leftAnchor, constant: 40).isActive = true
        
    }
    
    
    // call function
    @objc func callEmergency() {
        
        guard let number = URL(string: "telprompt://+319007788990") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(number)
        }
    }
    
    
    //animate adress view with delay
    func animateView() {
        
        UIView.animate(withDuration: 0.5, delay: 1.2, options: [.curveEaseOut], animations: {
            
            self.addressView.alpha = 1
            
        }, completion: nil)
    }
    
    // show alert
    func showAlert(title: String, contentText: String, actions: [UIAlertAction]) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: contentText, preferredStyle: .alert)
            for action in actions {
                alertController.addAction(action)
            }
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // setup views (map, button, addressview)
    func setupViews() {
        
        // image inside button
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ic_phone")
        
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        view.addSubview(callButton)
        callButton.addSubview(image)
        view.addSubview(addressView)
        
        
        // setup constraints
        mapView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        callButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        callButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        callButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        image.centerYAnchor.constraint(equalTo: callButton.centerYAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: callButton.leftAnchor, constant: 50).isActive = true
        
        addressView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        addressView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        addressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -110).isActive = true
        
    }
    
    

    
    // setup views for (headline, infotext, userAdress) in adress view
    func setupAddress(with text: String) {
        
        let headline = UILabel()
        headline.translatesAutoresizingMaskIntoConstraints = false
        headline.font = UIFont.boldSystemFont(ofSize: 18)
        headline.textColor = .white
        headline.text = "Uw locatie:"
        
        let infoText = UILabel()
        infoText.translatesAutoresizingMaskIntoConstraints = false
        infoText.font = UIFont.systemFont(ofSize: 14)
        infoText.textColor = .white
        infoText.numberOfLines = 0
        infoText.textAlignment = .center
        infoText.text = "Onthoud deze locatie voor het telefoongesprek"
        
        let userAddress = UILabel()
        userAddress.translatesAutoresizingMaskIntoConstraints = false
        userAddress.font = UIFont.systemFont(ofSize: 16)
        userAddress.textColor = .white
        userAddress.numberOfLines = 0
        userAddress.textAlignment = .center
        userAddress.text = text
        
        // add views to subview
        addressView.addSubview(headline)
        addressView.addSubview(infoText)
        addressView.addSubview(userAddress)
        
        
        //setup constraints
        headline.topAnchor.constraint(equalTo: addressView.topAnchor, constant: 20).isActive = true
        headline.centerXAnchor.constraint(equalTo: addressView.centerXAnchor).isActive = true
        
        userAddress.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 20).isActive = true
        userAddress.centerXAnchor.constraint(equalTo: addressView.centerXAnchor).isActive = true
        userAddress.widthAnchor.constraint(equalToConstant: 220).isActive = true
        
        infoText.bottomAnchor.constraint(equalTo: addressView.bottomAnchor, constant: -40).isActive = true
        infoText.centerXAnchor.constraint(equalTo: addressView.centerXAnchor).isActive = true
        infoText.widthAnchor.constraint(equalToConstant: 220).isActive = true
    }
    
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // remove last location, otherwise it will be added again, and..
        mapView.removeAnnotation(pin)
        
        let location = locations[0]
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegion(center: userLocation, span: span)
        
        //set region on the map
        mapView.setRegion(region, animated: true)
        
        pin.coordinate = userLocation
        
        //add pin to map
        mapView.addAnnotation(pin)
        
        
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
            
            let text = "\(street) \(number),\n\(zip), \(city)"
            
            //setup address when loaded
            self.setupAddress(with: text)
            
            // stop locating user (map stops moving)
            self.locationManager?.stopUpdatingLocation()
            
        })
        
        
    }

}


