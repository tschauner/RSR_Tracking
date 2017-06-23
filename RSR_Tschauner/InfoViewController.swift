//
//  InfoViewController.swift
//  RSR_Tschauner
//
//  Created by Philipp Tschauner on 20.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    
    // infotext in textview
    let text = "Met de hulp van RSR blift u mobiel. RSR is dé leverancier van hulpmiddelen in de regio Noordoost-Nederland. Gedegen kennis en jarenlange ervaring zit in ons DNA verweven en leidt tot het beste advies. \n\nWilt u meer weten over onze producten en diensten, kijk dan op www.rsr.nl of bezoek onze showrooms in Silvolde en Nieuwleusen. We zijn iedere werkdag geopend van 8.00 tot 17.00 uur. Hier kunt u diverse hulpiddelen uitproberen en rustig bekiiken wat goed bij uw situatie aansluit. Samen met u zoeken we naar hulpmiddelen dat bij u past. RSR maakt mensen mobiel."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        setupViews()
    }
    
    
    
    // setup bigger title
    func setupNavBar() {
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = .white
        title.text = "Over RSR"
        title.sizeToFit()
        
        navigationItem.titleView = title
        
    }
    
    
    // setup views for (headerImage, line, text)
    func setupViews() {
        
        view.backgroundColor = .white
        
        let headerImage = UIImageView()
        headerImage.translatesAutoresizingMaskIntoConstraints = false
        headerImage.contentMode = .scaleAspectFill
        headerImage.image = UIImage(named: "over_image")
        
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = HomeController.rsrBlue
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = text
        textView.textColor = .gray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isSelectable = true
        textView.isEditable = false
        
        //highlights link in textview and makes in clickable
        textView.dataDetectorTypes = UIDataDetectorTypes.link

        // add views to subview
        view.addSubview(headerImage)
        view.addSubview(lineView)
        view.addSubview(textView)
        
        //setup constraints
        headerImage.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        headerImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
        lineView.topAnchor.constraint(equalTo: headerImage.bottomAnchor).isActive = true
        lineView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 7).isActive = true
        
        textView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 10).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
}



