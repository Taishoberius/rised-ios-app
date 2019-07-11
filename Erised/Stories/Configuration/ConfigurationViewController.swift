//
//  ConfigurationViewController.swift
//  Erised
//
//  Created by David Linhares on 27/06/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {
    @IBOutlet weak var configureButton: UIButton!
    @IBOutlet weak var mirrorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureButton.layer.cornerRadius = 15
        configureButton.backgroundColor = UIColor.secondaryColor()
        mirrorButton.layer.cornerRadius = 15
        mirrorButton.backgroundColor = UIColor.secondaryColor()
    }

    @IBAction func didtouchUse(_ sender: Any) {
        AppFileManager.Config.write("true")
        let vc = AppStoryboard.Home.instantiateInitialViewController()
        present(vc, animated: true)
    }
}
