//
//  PreferencesDelegate.swift
//  Erised
//
//  Created by David Linhares on 09/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import Foundation

protocol PreferencesDelegate {
    func preferencesDidChange(_ preferences: Preferences)
}
