//
//  HomeViewController.swift
//  Erised
//
//  Created by David Linhares on 27/06/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit

class HomePreferencesController: UIViewController {

    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var reminderText: UITextView!
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
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
    @IBOutlet weak var noteButton: UIButton!
    @IBOutlet weak var newsButton: UIButton!
    
    var delegate: PreferencesDelegate?
    
    private var preferencesHasChanged = false
    private var isReturn = false
    private var news = [News]()
    private var showedView: UIView!

    var preferences: Preferences! {
        didSet {
            if oldValue != nil {
                delegate?.preferencesDidChange(self.preferences)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reminderText.delegate = self
        newsTableView.delegate = self
        newsTableView.dataSource = self
        fetchNews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showedView = prefStackview
        setupUI()
    }

    func setupUI() {
        tempLabel.alpha = 0.7
        humidityLabel.alpha = 0.7
        setupLabel(tempLabel, userPref: preferences.temperature)
        setupLabel(humidityLabel, userPref: preferences.humidity)
        setupLabel(notesLabel, userPref: preferences.notes)
        setupLabel(newsLabel, userPref: preferences.news)
        setupItinerary(preferences.itinerary, transportType: TransportType.build(rawValue: preferences.transportType))
        setupWeather()
        buttons.forEach {
            $0.layer.cornerRadius = 15
            $0.layer.borderColor = UIColor.tertiaryColor().cgColor
            $0.layer.borderWidth = 2
        }
        labels.forEach {
            $0.textColor = .white
        }
        setAddressButton.tintColor = UIColor.secondaryColor()
        reminderView.layer.cornerRadius = 15
        reminderView.layer.borderWidth = 2
        reminderView.layer.borderColor = UIColor.white.cgColor
        newsView.layer.cornerRadius = 15
        newsView.layer.borderWidth = 2
        newsView.layer.borderColor = UIColor.white.cgColor
        reminderText.text = preferences.notesText
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
        if sender == noteButton {
            onNotestouched()
        }
        if sender == newsButton {
            onNewstouched()
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
        delegate?.touchToothBrushNotification()
    }

    @IBAction func didTouchReminder(_ sender: Any) {
        if reminderView.alpha == 0 {
            flipToView(option: .right, to: reminderView)
            return
        }

        flipToView(option: .left, to: prefStackview)
    }

    @IBAction func didTouchNews(_ sender: Any) {
        if newsView.alpha == 0 {
            flipToView(option: .right, to: newsView)
            return
        }

        flipToView(option: .left, to: prefStackview)
    }

    private enum FlipMode {
        case left
        case right
    }

    @IBAction func didTouchReminderClose(_ sender: Any) {
        flipToView(option: .left, to: prefStackview)
        saveReminder()
    }

    @IBAction func didtouchCloseNews(_ sender: Any) {
        flipToView(option: .left, to: prefStackview)
    }

    private func flipToView(option: FlipMode, to otherView: UIView) {
        if showedView == otherView {
            return
        }

        let animation: UIView.AnimationOptions
        if option == .right {
            animation = .transitionFlipFromRight
        } else {
            animation = .transitionFlipFromLeft
        }

        UIView.animate(withDuration: 0.7, delay: 0, options: animation, animations: {
            self.showedView.alpha = 0
            self.showedView.transform = CGAffineTransform.init(scaleX: -1, y: 1)
            otherView.alpha = 1
        }, completion: { _ in
            self.showedView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.showedView = otherView
        })
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

    private func onNewstouched() {
        preferences.news = !preferences.news
    }

    private func onNotestouched() {
        preferences.notes = !preferences.notes
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

    func fetchNews() {
        Service.instance.getNews {
            self.news = $0
            self.newsTableView.reloadData()
        }
    }
}

extension HomePreferencesController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "\n" && isReturn {
            saveReminder()
        }

        isReturn = text == "\n"

        if textView.text.count > 280 {
            return false
        }

        return true
    }

    func saveReminder() {
        reminderText.resignFirstResponder()
        preferences.notesText = reminderText.text
    }
}

extension HomePreferencesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        guard let url = URL(string: news[indexPath.row].url) else {
            return
        }

        UIApplication.shared.open(url, options: [:])
    }
}

extension HomePreferencesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.textLabel?.text = news[indexPath.row].title
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white

        return cell
    }


}
