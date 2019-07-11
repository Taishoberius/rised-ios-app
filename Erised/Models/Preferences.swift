//
//  Preferences.swift
//  Erised
//
//  Created by David Linhares on 07/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import Foundation

struct Preferences: Codable {
    var weather: Int = 0
    var address: String = ""
    var workAddress: String = " "
    var transportType: String
    var temperature: Bool = false
    var humidity: Bool = false
    var itinerary: Bool = false
    var name: String = ""
    var deviceName: String = ""

    init(weather: Int = 0, address: String = "", workAddress: String = "", transportType: TransportType = .vehicule, temperature: Bool = false, humidity: Bool = false, itinerary: Bool = false, name: String = "", deviceName: String = "") {
        self.weather = weather
        self.address = address
        self.workAddress = workAddress
        self.transportType = transportType.rawValue
        self.temperature = temperature
        self.humidity = humidity
        self.itinerary = itinerary
        self.name = name
        self.deviceName = deviceName
    }
}
