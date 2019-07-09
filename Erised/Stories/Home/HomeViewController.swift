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
    private var preferences: Preferences!

    var profileController = AppStoryboard.Home.viewController(viewControllerClass: HomeProfileViewController.self)
    var preferencesController = AppStoryboard.Home.viewController(viewControllerClass: HomePreferencesController.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        profileButton.layer.borderWidth = 1
        settingsButton.layer.borderWidth = 1
        profileButton.layer.cornerRadius = 15
        settingsButton.layer.cornerRadius = 15
        profileButton.layer.borderColor = UIColor.tertiaryColor().cgColor
        settingsButton.layer.borderColor = UIColor.tertiaryColor().cgColor
        self.preferences = fetchPreferences()
        preferencesController.preferences = preferences
        preferencesController.delegate = self
        profileController.preferences = preferences
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

    private func fetchPreferences() -> Preferences {
        let preferencesString = AppFileManager.Preferences.getFileContent()
        if preferencesString.isEmpty {
            return createDefaultPreferences()
        }

        guard let data = preferencesString.data(using: .utf8) else {
            return createDefaultPreferences()
        }


        guard let preferences = try? JSONDecoder().decode(Preferences.self, from: data) else {
            return createDefaultPreferences()
        }

        return preferences
    }

    private func createDefaultPreferences() -> Preferences {
        let pref = Preferences(weather: 0, address: nil, workAddress: nil, transporType: .vehicule, temperature: false, humidity: false, itinerary: false, name: nil, deviceName: UIDevice.current.name)

        guard let json = try? JSONEncoder().encode(pref) else {
            return pref
        }

        AppFileManager.Preferences.write(String(data: json, encoding: .utf8) ?? "")

        return pref
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
                setController(profileController)
            }
        case .setting:
            settingsImage.image = UIImage(named: "fa-secondary-settings")
            userImage.image = UIImage(named: "fa-user")
            settingsButton.layer.borderColor = UIColor.secondaryColor().cgColor
            profileButton.layer.borderColor = UIColor.tertiaryColor().cgColor
            if !isSettingsShowed {
                isSettingsShowed = true
                setController(preferencesController)
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
            UIView.animate(withDuration: 0.3) {
                previous.frame.origin.x = controller.view.frame.origin.x * -1
            }
            previous.removeFromSuperview()
        }

        UIView.animate(withDuration: 0.3, animations: {
            controller.view.frame.origin.x = 0
        })

        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}

extension HomeViewController: PreferencesDelegate {
    func preferencesDidChange(_ preferences: Preferences) {
        //do stuff
    }
}
