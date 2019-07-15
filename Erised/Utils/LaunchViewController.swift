//
//  LaunchViewController.swift
//  Erised
//
//  Created by David Linhares on 15/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.viewImage.transform = CGAffineTransform(rotationAngle: .pi)
        }
        UIView.animate(withDuration: 1, animations: {
            self.viewImage.transform = CGAffineTransform(rotationAngle: 0)
        }) { _ in
            self.launchDefaultScreen()
        }
    }

    func launchDefaultScreen() {
        let window = UIApplication.shared.windows
        if AppFileManager.Config.getFileContent().isEmpty {
            window.first?.rootViewController = AppStoryboard.Configuration.instantiateInitialViewController()
        } else {
            window.first?.rootViewController = AppStoryboard.Home.instantiateInitialViewController()
        }
    }
}
