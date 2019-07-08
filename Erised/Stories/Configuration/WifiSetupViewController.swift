//
//  WifiSetupViewController.swift
//  Erised
//
//  Created by David Linhares on 28/06/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit
import CoreBluetooth

class WifiSetupViewController: UIViewController {

    @IBOutlet weak var ssidField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var validateButton: UIButton!

    var device: CBPeripheral!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        validateButton.layer.cornerRadius = 15
        ssidField.delegate = self
        passwordField.delegate = self
        device.delegate = self
        validateButton.isEnabled = false

        device.discoverServices(nil)
    }

    @IBAction func didTouchValidate(_ sender: Any) {
        let str = "conf: \(ssidField.text ?? "") \(passwordField.text ?? "")"
        let service = device.services?.first

        let data = str.data(using: .utf8)
        let char = service?.characteristics?.first

        device.writeValue(data!, for: char!, type: .withoutResponse)
    }
}

extension WifiSetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validateButton.isEnabled = !(textField.text?.isEmpty ?? false)
        textField.resignFirstResponder()
        return true
    }
}

extension WifiSetupViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        device = peripheral
        let service = device.services?.first
        device.discoverCharacteristics(nil, for: service!)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        validateButton.isEnabled = true
        device = peripheral
    }
}
