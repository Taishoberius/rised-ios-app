//
//  HomeViewController.swift
//  Erised
//
//  Created by David Linhares on 27/06/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit

class HomePreferencesController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var prefStackview: UIStackView!
    @IBOutlet weak var itinéraryButton: UIButton!
    @IBOutlet weak var itineraryLabel: UILabel!
    @IBOutlet weak var humidityButton: UIButton!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tempButton: UIButton!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var setAddressButton: UIButton!
    
    var delegate: PreferencesDelegate?
    
    private var preferencesHasChanged = false
    var preferences: Preferences! {
        didSet {
            if oldValue != nil {
                delegate?.preferencesDidChange(self.preferences)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
    }

    private func setupUI() {
        setupLabel(tempLabel, userPref: preferences.temperature)
        setupLabel(humidityLabel, userPref: preferences.humidity)
        setupItinerary(preferences.itinerary, transportType: TransportType.build(rawValue: preferences.transportType))
        setupWeather()
        buttons.forEach {
            $0.layer.cornerRadius = 15
            $0.layer.borderColor = UIColor.tertiaryColor().cgColor
            $0.layer.borderWidth = 2
        }
        labels.forEach {
            $0.textColor = UIColor.secondaryColor()
        }
        setAddressButton.tintColor = UIColor.secondaryColor()
    }

    private func setupLabel(_ label: UILabel ,userPref: Bool) {
        label.text = userPref ? "Oui" : "Non"
    }

    private func setupItinerary(_ showed: Bool, transportType: TransportType) {
        if showed {
            itineraryLabel.text = "\(transportType)"
            return
        }

        itineraryLabel.text = "Non"
        setupAddressButton()
    }

    private func setupWeather() {
        let day = preferences.weather > 1 ? "jours" : "jour"
        weatherLabel.text = preferences.weather == 0 ? "Non" : "\(preferences.weather) \(day)"
    }

    @IBAction func didTouchButton(_ sender: UIButton) {
        preferencesHasChanged = true

        if sender == weatherButton {
            onWeatherTouched()
        }
        if sender == tempButton {
            onTempTouched()
        }
        if sender == humidityButton {
            onHumiditytouched()
        }
        if sender == itinéraryButton {
            onItineraryTouched()
        }

        setupUI()
    }

    @IBAction func didTouchAddress(_ sender: UIButton) {
        self.delegate?.changeSettingPage(from: HomePreferencesController.self)
    }

    @IBAction func didTouchInitialize(_ sender: Any) {
        self.present(AppStoryboard.Configuration.instantiateInitialViewController(), animated: true)
    }

    @IBAction func didTouchtoothBrush(_ sender: Any) {
    }

    private func onWeatherTouched() {
        var weather = preferences.weather
        weather = weather == 5 ? 0 : weather + 1
        preferences.weather = weather
    }

    private func onTempTouched() {
        preferences.temperature = !preferences.temperature
    }

    private func onHumiditytouched() {
        preferences.humidity = !preferences.humidity
    }

    private func onItineraryTouched() {
        let type = TransportType(rawValue: preferences.transportType)
        if !preferences.itinerary {
            preferences.itinerary = !preferences.itinerary
        } else if type == .vehicule {
            preferences.transportType = TransportType.transport.rawValue
        } else {
            preferences.itinerary = false
            preferences.transportType = TransportType.vehicule.rawValue
        }
        setupAddressButton()
    }

    private func setupAddressButton() {
        self.setAddressButton.isHidden = (preferences.itinerary &&  AddressManager.isAddressComplete(preferences.address) && AddressManager.isAddressComplete(preferences.workAddress)) || !preferences.itinerary
    }

}
