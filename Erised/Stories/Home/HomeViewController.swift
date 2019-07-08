//
//  HomeViewController.swift
//  Erised
//
//  Created by David Linhares on 27/06/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var prefStackview: UIStackView!
    @IBOutlet weak var endCity: UITextField!
    @IBOutlet weak var endZipcode: UITextField!
    @IBOutlet weak var endAddress: UITextField!
    @IBOutlet weak var endAddressView: UIView!
    @IBOutlet weak var startCityText: UITextField!
    @IBOutlet weak var startZipcodeText: UITextField!
    @IBOutlet weak var startAddressText: UITextField!
    @IBOutlet weak var startAddressView: UIView!
    @IBOutlet weak var itinéraryButton: UIButton!
    @IBOutlet weak var itineraryLabel: UILabel!
    @IBOutlet weak var humidityButton: UIButton!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tempButton: UIButton!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherButton: UIButton!
    

    private var preferences: Preferences!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferences = fetchPreferences()
         setupUI()
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
        let pref = Preferences(weather: 0, address: nil, transporType: .vehicule, temperature: false, humidity: false, itinerary: false)

        guard let json = try? JSONEncoder().encode(pref) else {
            return pref
        }

        AppFileManager.Preferences.write(String(data: json, encoding: .utf8) ?? "")

        return pref
    }

    private func setupUI() {
        setupLabel(tempLabel, userPref: preferences.temperature)
        setupLabel(humidityLabel, userPref: preferences.humidity)
        setupItinerary(preferences.itinerary, transportType: preferences.transporType)
        setupWeather()
        buttons.forEach {
            $0.layer.cornerRadius = 15
            $0.layer.borderColor = UIColor.blue.cgColor
            $0.layer.borderWidth = 2
        }
    }

    private func setupLabel(_ label: UILabel ,userPref: Bool) {
        label.text = userPref ? "Oui" : "Non"
    }

    private func setupItinerary(_ showed: Bool, transportType: TransportType) {
        startAddressView.isHidden = !showed
        endAddressView.isHidden = !showed

        if showed {
            itineraryLabel.text = "\(transportType)"
            return
        }

        itineraryLabel.text = "Non"
    }

    private func setupWeather() {
        weatherLabel.text = preferences.weather == 0 ? "Non" : "\(preferences.weather)"
    }
}
