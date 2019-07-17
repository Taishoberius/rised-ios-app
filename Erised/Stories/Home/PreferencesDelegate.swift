//
//  PreferencesDelegate.swift
//  Erised
//
//  Created by David Linhares on 09/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import Foundation
import UIKit

protocol PreferencesDelegate {
    func preferencesDidChange(_ preferences: Preferences)
    func changeSettingPage(from controller: UIViewController.Type)
    func touchToothBrushNotification()
}
