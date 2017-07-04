//
//  ViewController.swift
//  RSR_Tschauner
//
//  Created by Philipp Tschauner on 20.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation

class HomeController: UIViewController {
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        initLocationManger()
        detectScreenSizeAndAdjustViews()
    }

    
    // ------ views ------
    
    let mapButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitle("   RSR Pechulp", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: "btn_pressed"), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.addTarget(self, action: #selector(showUserLocation), for: .touchUpInside)
        return button
    }()
    
    let infoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.isHidden = true
        button.clipsToBounds = true
        button.setTitle("  Over RSR", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: "btn_pressed"), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        return button
    }()
    
    
    
    // ------ functions -----
    
    // detects screens size of devices and adjust views
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
            case 0...320:
                // iPhone 5 portrait
                setupViewsFor(device: .iPhone5)
            default:
                // iPhone 6/7 Plus portrait
                setupViewsFor(device: .iPhone67plus)
            }
        case .pad:
            // iPad 2, Air, Retina and Mini etc Portrait
            setupViewsFor(device: .iPad)
        default:
            break
        }
    }
    
    
    
    // initializes location manger - request locations service
    func initLocationManger() {
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
    }
    
    // device options
    enum Devices {
        case iPad
        case iPhone67plus
        case iPhone5
    }
    
    
    // setup bigger navbar title
    func setupNavBar() {
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = .white
        title.text = "RSR Revalidatieservice"
        title.sizeToFit()
        
        navigationItem.titleView = title
    }
    
    // shows infoButton in nav bar
    func setupInfoButton() {
        
        let infoButton = UIBarButtonItem(image: UIImage(named: "ic_over_normal"), style: .plain, target: self, action: #selector(showInfo))
        
        navigationItem.rightBarButtonItem = infoButton
    }
    
    // adjust and setup views for each iphone
    func setupViewsFor(device: Devices) {
        
        var backGroundImageString: String
        var buttonPadding: CGFloat
        var buttonBottomPadding: CGFloat
        var buttonImagePadding: CGFloat = 50
        
        // adjust padding depending on device
        switch device {
        case .iPhone67plus:
            backGroundImageString = "img_background-i5"
            buttonPadding = -50
            buttonBottomPadding = -50
            buttonImagePadding = 50
            setupInfoButton()
        case .iPhone5:
            backGroundImageString = "img_background-i5"
            buttonPadding = -50
            buttonBottomPadding = -50
            buttonImagePadding = 20
            setupInfoButton()
            mapButton.setTitle("     RSR Pechulp", for: .normal)
        case .iPad:
            backGroundImageString = "img_background_ipad"
            buttonPadding = -350
            buttonBottomPadding = -130
            infoButton.isHidden = false
        }
        
        // background Image in view
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = UIImage(named: backGroundImageString)
        
        // image inside mapButton
        let buttonImage = UIImageView()
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        buttonImage.image = UIImage(named: "ic_attention")
        
        // image inside button
        let infoImage = UIImageView()
        infoImage.translatesAutoresizingMaskIntoConstraints = false
        infoImage.image = UIImage(named: "ic_over_normal")
        
        
        // add views to subview
        view.addSubview(backgroundImage)
        view.addSubview(mapButton)
        mapButton.addSubview(buttonImage)
        infoButton.addSubview(infoImage)
        view.addSubview(infoButton)
        
        
        //setup connstraints
        backgroundImage.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        mapButton.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: buttonBottomPadding).isActive = true
        mapButton.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor).isActive = true
        mapButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: buttonPadding).isActive = true
        mapButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        buttonImage.centerYAnchor.constraint(equalTo: mapButton.centerYAnchor).isActive = true
        buttonImage.leftAnchor.constraint(equalTo: mapButton.leftAnchor, constant: buttonImagePadding).isActive = true
        
        infoButton.topAnchor.constraint(equalTo: mapButton.bottomAnchor, constant: 20).isActive = true
        infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoButton.widthAnchor.constraint(equalTo: mapButton.widthAnchor).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        infoImage.centerYAnchor.constraint(equalTo: infoButton.centerYAnchor).isActive = true
        infoImage.leftAnchor.constraint(equalTo: infoButton.leftAnchor, constant: 55).isActive = true
    }
    
    
    
    //user clicks on info button, show info view controller
    @objc func showInfo() {
        
        let infoVC = InfoViewController()
        
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
    
    //user click on button, show map view controller
    @objc func showUserLocation() {
        
        let mapVC = MapViewController()
        
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    
    
}


