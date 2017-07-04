//
//  InfoViewController.swift
//  RSR_Tschauner
//
//  Created by Philipp Tschauner on 20.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var linePadding: CGFloat = 0
    
    // infotext in textview
    let text = "Met de hulp van RSR blift u mobiel. RSR is dé leverancier van hulpmiddelen in de regio Noordoost-Nederland. Gedegen kennis en jarenlange ervaring zit in ons DNA verweven en leidt tot het beste advies. \n\nWilt u meer weten over onze producten en diensten, kijk dan op www.rsr.nl of bezoek onze showrooms in Silvolde en Nieuwleusen. We zijn iedere werkdag geopend van 8.00 tot 17.00 uur. Hier kunt u diverse hulpiddelen uitproberen en rustig bekiiken wat goed bij uw situatie aansluit. Samen met u zoeken we naar hulpmiddelen dat bij u past. RSR maakt mensen mobiel."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        detectScreenSizeAndAdjustViews()
        
    }
    
    
    // setup bigger title
    func setupNavBar() {
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = .white
        title.text = "Over RSR"
        title.sizeToFit()
        
        navigationItem.titleView = title
        
        // change backbutton title
        navigationController!.navigationBar.topItem!.title = "Terug"
        
    }
    
    // supported devices
    enum Devices {
        case iPhone5SE
        case iPhone67
        case iPhone67plus
        case iPadmini
        case iPad10
        case iPad12
    }
    
    // detects the screen size of device and adjust views
    func detectScreenSizeAndAdjustViews() {
        
        // Screen size detection
        let screenSize: CGRect = UIScreen.main.bounds
        
        // Access in the current screen width and height
        let screenWidth = screenSize.width
        
        // Request an UITraitCollection instance
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        switch (deviceIdiom) {
            
        case .phone:
            switch screenWidth {
            case 0...320:
                // iPhone 5 portrait
                setupViewsfrom(device: .iPhone5SE)
                print("5")
            case 321...375:
                // iPhone 6/7 portrait
                print("7")
                setupViewsfrom(device: .iPhone67)
                
            default:
                // iPhone 6/7 Plus portrait
                print("7 plus")
                setupViewsfrom(device: .iPhone67plus)
            }
        case .pad:
            switch screenWidth {
            case 0...768:
                // ipad mini & ipad
                setupViewsfrom(device: .iPadmini)
                
                print("mini")
            case 769...834:
                // ipad pro 10 inch
                print("10 inch")
                setupViewsfrom(device: .iPad10)
                
            default:
                // ipad pro 12 inch
                print("12 inch")
                setupViewsfrom(device: .iPad12)
            }
        default:
            break
        }
    }
    
    
    // setup views for (headerImage, line, text)
    func setupViewsfrom(device: Devices) {
        
        // somehow constraints doesnt work properly at a iphone 7 plus - ipad size
        // thats why i need to adjust them individually
        
        let textPadding: CGFloat
        let linePadding: CGFloat
        let lineHeight: CGFloat
        let imageHeight: CGFloat
        
        switch device {
        case .iPhone5SE:
            textPadding = -20
            linePadding = 7
            lineHeight = 7
            imageHeight = 200
            
        case .iPhone67:
            textPadding = -40
            linePadding = 7
            lineHeight = 7
            imageHeight = 230
            
        case .iPhone67plus:
            textPadding = -40
            linePadding = 20
            lineHeight = 7
            imageHeight = 230
            
        case .iPadmini:
            textPadding = -150
            linePadding = 75
            lineHeight = 12
            imageHeight = 350
            
        case .iPad10:
            textPadding = -150
            linePadding = 100
            lineHeight = 12
            imageHeight = 350
            
        case .iPad12:
            textPadding = -150
            linePadding = 170
            lineHeight = 12
            imageHeight = 350
            
        }
        
        view.backgroundColor = .white
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        
        let headerImage = UIImageView()
        headerImage.translatesAutoresizingMaskIntoConstraints = false
        headerImage.contentMode = .scaleAspectFill
        headerImage.image = UIImage(named: "over_image")
        
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = Constants.rsrBlue
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = text
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.textColor = .gray
        textView.font = UIFont.systemFont(ofSize: 16)
        //highlights link in textview and makes in clickable
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        
        // add views to subview
        view.addSubview(scrollView)
        scrollView.addSubview(headerImage)
        scrollView.addSubview(lineView)
        scrollView.addSubview(textView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //setup constraints
        headerImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: linePadding).isActive = true
        headerImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        
        lineView.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: linePadding).isActive = true
        lineView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true
        
        textView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20).isActive = true
        textView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: textPadding).isActive = true
        textView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        
        // in case its an ipad, adjust  views
        switch device {
        case .iPadmini, .iPad10, .iPad12:
            
            let infoImage = UIImageView()
            infoImage.translatesAutoresizingMaskIntoConstraints = false
            infoImage.image = UIImage(named: "small_logo_ipad")
            infoImage.contentMode = .scaleAspectFill
            
            scrollView.addSubview(infoImage)
            
            infoImage.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20).isActive = true
            infoImage.centerXAnchor.constraint(equalTo: textView.centerXAnchor).isActive = true
            infoImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
            infoImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
            
        default:
            
            print("i am an iphone")
        }
        
        
    }
    
}



