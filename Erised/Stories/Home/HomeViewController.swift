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
    @IBOutlet weak var buttonValidate: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var isSettingsShowed = true
    private var preferences: Preferences!
    private var modifiedPreferences: Preferences? = nil
    private var userId: String!

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
        profileController.delegate = self
        buttonValidate.layer.cornerRadius = 15
        buttonValidate.backgroundColor = UIColor.infoColor()
        buttonValidate.setTitleColor(UIColor.infoSecondaryColor(), for: .normal)
        buttonValidate.alpha = 0
        activityIndicator.color = UIColor.infoColor()
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
        self.userId = AppFileManager.UserPreferenceId.getFileContent()
        let preferencesString = AppFileManager.Preferences.getFileContent()

        guard !userId.isEmpty,
            let data = preferencesString.data(using: .utf8),
            let preferences = try? JSONDecoder().decode(Preferences.self, from: data) else {
            return createDefaultPreferences()
        }

        return preferences
    }

    private func createDefaultPreferences() -> Preferences {
        let pref = Preferences()
        Service.instance.createPreference(preference: pref) {
            if let id = $0 {
                AppFileManager.UserPreferenceId.write(id)
            }
        }

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
                profileController.preferences = preferences
                setController(profileController)
            }
        case .setting:
            settingsImage.image = UIImage(named: "fa-secondary-settings")
            userImage.image = UIImage(named: "fa-user")
            settingsButton.layer.borderColor = UIColor.secondaryColor().cgColor
            profileButton.layer.borderColor = UIColor.tertiaryColor().cgColor
            if !isSettingsShowed {
                isSettingsShowed = true
                preferencesController.preferences = preferences
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

    @IBAction func didTouchValidate(_ sender: Any) {
        guard let preference = modifiedPreferences else {
            return
        }

        self.activityIndicator.startAnimating()
        self.preferences = preference
        self.validateButtonAnimation(alpha: 0, enabled: false)
        Service.instance.updatePreference(id: userId, preference: preferences) {
            self.activityIndicator.stopAnimating()
            guard let preference = $0 else {

                return
            }

            self.preferences = preference

            guard let encoder = try? JSONEncoder().encode(preference),
            let data = String(data: encoder, encoding: .utf8) else {
                return
            }

            AppFileManager.Preferences.write(data)
        }
    }

    private func validateButtonAnimation(alpha: CGFloat, enabled: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.buttonValidate.alpha = alpha
        }, completion: { _ in
            self.buttonValidate.isEnabled = enabled
        })
    }
}

extension HomeViewController: PreferencesDelegate {
    func changeSettingPage(from controller: UIViewController.Type) {
        if controller is HomePreferencesController.Type {
            selectButton(profileButton, type: .user)
            return
        }

        selectButton(settingsButton, type: .setting)
    }

    func preferencesDidChange(_ preferences: Preferences) {
        if !comparePreferences(preferences) {
            self.modifiedPreferences = preferences
            validateButtonAnimation(alpha: 1, enabled: true)
            return
        }

        validateButtonAnimation(alpha: 0, enabled: false)
    }

    private func comparePreferences(_ preference: Preferences) -> Bool {
        return preferences.address == preference.address &&
        preferences.name == preference.name &&
        preferences.workAddress == preference.workAddress &&
        preferences.deviceName == preference.deviceName &&
        preferences.itinerary == preference.itinerary &&
        preferences.humidity == preference.humidity &&
        preferences.temperature == preference.temperature &&
        preferences.weather == preference.weather &&
        preferences.transportType == preference.transportType
    }
}
