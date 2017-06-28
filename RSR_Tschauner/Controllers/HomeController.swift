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
        button.setTitle("   Over RSR", for: .normal)
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
                mapButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                setupViewsWith(button: true)
            default:
                // iPhone 6/7 Plus portrait
                setupViewsWith(button: true)
            }
        case .pad:
            // iPad 2, Air, Retina and Mini etc Portrait
            setupViewsWith(button: false)
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
        case iPhone
    }
    
    // adjust and setup views for each device
    func setupViewsFor(device: Devices) {
        
        let backGroundImageString: String
        let buttonPadding: CGFloat
        let buttonBottomPadding: CGFloat
        
        switch device {
        case .iPhone:
            backGroundImageString = "img_background-i5"
            buttonPadding = -50
            buttonBottomPadding = -50
        case .iPad:
            backGroundImageString = "img_background_ipad"
            buttonPadding = -300
            buttonBottomPadding = -130
        }
        
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = UIImage(named: backGroundImageString)
        
        // image inside button
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ic_attention")
        
        // image inside button
        let infoImage = UIImageView()
        infoImage.translatesAutoresizingMaskIntoConstraints = false
        infoImage.image = UIImage(named: "ic_over_normal")
        
        
        // add views to subview
        view.addSubview(backgroundImage)
        view.addSubview(mapButton)
        mapButton.addSubview(image)
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
        
        image.centerYAnchor.constraint(equalTo: mapButton.centerYAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: mapButton.leftAnchor, constant: 50).isActive = true
        
        infoButton.topAnchor.constraint(equalTo: mapButton.bottomAnchor, constant: 20).isActive = true
        infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoButton.widthAnchor.constraint(equalTo: mapButton.widthAnchor).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        infoImage.centerYAnchor.constraint(equalTo: infoButton.centerYAnchor).isActive = true
        infoImage.leftAnchor.constraint(equalTo: infoButton.leftAnchor, constant: 50).isActive = true
    }
    
    
    
    func setupViewsWith(button: Bool) {
        
        // setup nav bar with bigger title
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = .white
        title.text = "RSR Revalidatieservice"
        title.sizeToFit()
        
        navigationItem.titleView = title
        
        if button == true {
            
            // infoButton in navBar
            let infoButton = UIBarButtonItem(image: UIImage(named: "ic_over_normal"), style: .plain, target: self, action: #selector(showInfo))
            
            navigationItem.rightBarButtonItem = infoButton
            
            // padding on left - right = 25
            setupViewsFor(device: .iPhone)
            
            
        } else if button == false {
            
            print("ipad button")
            
            infoButton.isHidden = false
            
            // padding for left - right = 150
            setupViewsFor(device: .iPad)
            
        }
        
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


