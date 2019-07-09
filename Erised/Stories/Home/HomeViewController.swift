//
//  HomeViewController.swift
//  Erised
//
//  Created by David Linhares on 09/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private enum HomeButtonType {
        case user
        case setting
    }

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var settingsImage: UIImageView!

    private var isSettingsShowed = true

    override func viewDidLoad() {
        super.viewDidLoad()
        profileButton.layer.borderWidth = 1
        settingsButton.layer.borderWidth = 1
        profileButton.layer.cornerRadius = 15
        settingsButton.layer.cornerRadius = 15
        profileButton.layer.borderColor = UIColor.tertiaryColor().cgColor
        settingsButton.layer.borderColor = UIColor.tertiaryColor().cgColor
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.primaryColor()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.tertiaryColor()]
        title = "Erised"
        didTouchButton(profileButton)
    }

    
    @IBAction func didTouchButton(_ sender: UIButton) {
        if sender == profileButton {
            selectButton(sender, type: .user)
            return
        }

        selectButton(sender, type: .setting)
    }
    
    private func selectButton(_ sender: UIButton, type: HomeButtonType) {
        switch type {
        case .user:
            userImage.image = UIImage(named: "fa-secondary-user")
            settingsImage.image = UIImage(named: "fa-settings")
            profileButton.layer.borderColor = UIColor.secondaryColor().cgColor
            settingsButton.layer.borderColor = UIColor.tertiaryColor().cgColor
            if isSettingsShowed {
                isSettingsShowed = false
                setController(AppStoryboard.Home.viewController(viewControllerClass: HomeProfileViewController.self))
            }
        case .setting:
            settingsImage.image = UIImage(named: "fa-secondary-settings")
            userImage.image = UIImage(named: "fa-user")
            settingsButton.layer.borderColor = UIColor.secondaryColor().cgColor
            profileButton.layer.borderColor = UIColor.tertiaryColor().cgColor
            if !isSettingsShowed {
                isSettingsShowed = true
                setController(AppStoryboard.Home.viewController(viewControllerClass: HomePreferencesController.self))
            }
        }
    }

    private func setController(_ controller: UIViewController) {
        addChild(controller)
        controller.view.frame = containerView.bounds
        if controller is HomePreferencesController {
            controller.view.frame.origin.x = containerView.bounds.width
        } else {
            controller.view.frame.origin.x = -containerView.bounds.width
        }

        if let previous = containerView.subviews.first {
            UIView.animate(withDuration: 0.5) {
                previous.frame.origin.x = controller.view.frame.origin.x * -1
            }
            previous.removeFromSuperview()
        }

        UIView.animate(withDuration: 0.5, animations: {
            controller.view.frame.origin.x = 0
        })

        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}
