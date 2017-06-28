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
    
    var annotationView: MKAnnotationView?
    var userLocation = CLLocationCoordinate2D()
    
    // property observer for user address. sets address when data is loaded
    var userAddress: String? = nil {
        didSet {
            addressLabel.text = userAddress
        }
    }
    
    var pin = MKPointAnnotation()
    let geoCoder = CLGeocoder()
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupNavBar()
        
        initLocationManger()
        
        detectScreenSizeAndAdjustViews()
        
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
        button.setTitle("Annuleren", for: .normal)
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
        map.isUserInteractionEnabled = true
        return map
    }()
    
    var popup: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "popup_back")
        view.alpha = 0
        return view
    }()
    
    var addressView: UIView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var addressLabel: UILabel = {
        let address = UILabel()
        address.textAlignment = .center
        address.font = UIFont.systemFont(ofSize: 16)
        address.numberOfLines = 0
        address.lineBreakMode = .byWordWrapping
        address.textColor = .white
        return address
    }()
    
    
    
    // ----- functions -------
    
    
    // detects screen size and adjust views
    func detectScreenSizeAndAdjustViews() {
        
        // Screen size detection
        let screenSize: CGRect = UIScreen.main.bounds
        
        // Access in the current screen width and height
        let screenWidth = screenSize.width
        
        // Request an UITraitCollection instance
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        switch (deviceIdiom) {
        // Display myLabel with the appropriate font size for the device width.
        case .phone:
            switch screenWidth {
            case 0...375:
                // iPhone 5/6/7 portrait
                setupCallButton()
            default:
                // iPhone 6/7 Plus portrait
                setupCallButton()
            }
        case .pad:
            // iPad 2, Air, Retina and Mini etc Portrait
            showiPadInfo()
        default:
            break
        }
    }
    
    // initializes location manger
    func initLocationManger() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                showAlert(title: "GPS aanzetten", contentText: "U heeft deze app geen toegang gegeven voor GPS. Zet dit a.u.b. aan in uw instellingen.", actions: [action])
            case .authorizedAlways, .authorizedWhenInUse:
                print("access")
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
    
    
    // setup views (map, button, addressview)
    func setupViews() {
        
        mapView.delegate = self
        
        view.addSubview(mapView)
        
        // setup constraints
        mapView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    
    // setup nav bar title
    func setupNavBar() {
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = .white
        title.text = "RSR Pechulp"
        title.sizeToFit()
        
        navigationItem.titleView = title
        
        navigationController!.navigationBar.topItem!.title = "Terug"
        
    }
    
    
    // cancel call (popup fades out, shows rest)
    @objc func cancelCall() {
        
        UIView.animate(withDuration: 0.3) {
            self.popup.alpha = 0
            self.cancelButton.alpha = 0
            self.secondCallButton.alpha = 0
        }
        
        callButton.isHidden = false
        annotationView?.isHidden = false
        
    }
    
    
    // setup views for pop up (popup fades in, hides rest)
    @objc func showPopup() {
        
        UIView.animate(withDuration: 0.3) {
            self.popup.alpha = 1
            self.cancelButton.alpha = 1
            self.secondCallButton.alpha = 1
        }
        
        annotationView?.isHidden = true
        callButton.isHidden = true
        
        
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
    
    // shows the info bar at the bottom if device is an ipad
    func showiPadInfo() {
        
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = Constants.rsrBlue
        background.alpha = 0.8
        
        let headline = UILabel()
        headline.translatesAutoresizingMaskIntoConstraints = false
        headline.text = "Neem contact op met RSR Nederland"
        headline.textColor = .white
        headline.font = UIFont.boldSystemFont(ofSize: 18)
        
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "ic_phone")
        
        let info = UILabel()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.text = "Voor did nummer betaalt u uw gebruikelijke belkosten."
        info.textColor = .white
        info.font = UIFont.systemFont(ofSize: 14)
        
        let number = UILabel()
        number.translatesAutoresizingMaskIntoConstraints = false
        number.text = "   0900-7788990"
        number.textColor = .white
        number.font = UIFont.systemFont(ofSize: 22)
        
        // stack view for number with icon
        let infoNumber = UIStackView(arrangedSubviews: [icon, number])
        infoNumber.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(background)
        background.addSubview(headline)
        background.addSubview(infoNumber)
        background.addSubview(info)
        
        background.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        background.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        background.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        headline.topAnchor.constraint(equalTo: background.topAnchor, constant: 20).isActive = true
        headline.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        
        infoNumber.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        infoNumber.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        
        info.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -30).isActive = true
        info.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        
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
    
    
    // steup view for call button
    func setupCallButton() {
        
        // image inside button
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ic_phone")
        
        view.addSubview(callButton)
        callButton.addSubview(image)
        
        callButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        callButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        callButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        image.centerYAnchor.constraint(equalTo: callButton.centerYAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: callButton.leftAnchor, constant: 50).isActive = true
        
    }
}


