//
//  ViewController.swift
//  RSR_Tschauner
//
//  Created by Philipp Tschauner on 20.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // rsr colors
    static var rsrBlue = UIColor(red: 37/255, green: 161/255, blue: 196/255, alpha: 1)
    static var rsrGreen = UIColor(red: 203/255, green: 212/255, blue: 1/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavBar()
    }
    
    
    // ------ views ------
    
    let button: UIButton = {
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
    
    
    
    // ------ functions -----
    
    // setup nav bar with bigger title
    func setupNavBar() {
        
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = .white
        title.text = "RSR Revalidatieservice"
        title.sizeToFit()
        
        navigationItem.titleView = title
        
        // infoButton
        let infoButton = UIBarButtonItem(image: UIImage(named: "ic_over_normal"), style: .plain, target: self, action: #selector(showInfo))
        
        navigationItem.rightBarButtonItem = infoButton
        
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
    
    
    //setup background image and button
    func setupViews() {
        
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = UIImage(named: "img_background-i5")
        
        // image inside button
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "ic_attention")
        
        
        // add views to subview
        view.addSubview(backgroundImage)
        view.addSubview(button)
        button.addSubview(image)
        
        //setup connstraints
        
        backgroundImage.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        button.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -50).isActive = true
        button.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        image.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 50).isActive = true
        
    }
    
    
}


