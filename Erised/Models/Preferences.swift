//
//  Preferences.swift
//  Erised
//
//  Created by David Linhares on 07/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import Foundation

struct Preferences: Codable {
    var weather: Int
    var address: Address?
    var workAddress: Address?
    var transporType: TransportType = .vehicule
    var temperature: Bool
    var humidity: Bool
    var itinerary: Bool
    var name: String? = nil
    var deviceName: String
}
