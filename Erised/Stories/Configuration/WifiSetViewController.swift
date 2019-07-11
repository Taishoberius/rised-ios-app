//
//  WifiSetViewController.swift
//  Erised
//
//  Created by David Linhares on 07/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit

class WifiSetViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var useMirrorButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        useMirrorButton.layer.cornerRadius = 15
        label.textColor = UIColor.tertiaryColor()
        useMirrorButton.backgroundColor = UIColor.secondaryColor()
    }

    @IBAction func didTouchUse(_ sender: UIButton) {
        AppFileManager.Config.write("true")
        let vc = AppStoryboard.Home.instantiateInitialViewController()
        present(vc, animated: true, completion: nil)
    }
}
