//
//  SearchErisedViewController.swift
//  Erised
//
//  Created by David Linhares on 27/06/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit
import CoreBluetooth

class SearchErisedViewController: UIViewController {

    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!


    private var centralManager: CBCentralManager!
    private var erisedDevice: CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retryButton.layer.cornerRadius = 15
        retryButton.backgroundColor = UIColor.secondaryColor()
        infoLabel.textColor = UIColor.tertiaryColor()
        label.textColor = UIColor.tertiaryColor()
        activityIndicator.color = UIColor.secondaryColor()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        centralManager.delegate = nil
    }

    @IBAction func didTouchRetry(_ sender: Any) {
        searchErised()
    }

    private func askEnableBluetooth() {
        self.infoLabel.text = "Veuillez activer votre bluetooth"
        self.infoLabel.isHidden = false
        self.retryButton.isHidden = false
        self.activityIndicator.stopAnimating()
    }

    private func searchErised() {
        self.infoLabel.isHidden = true
        self.activityIndicator.startAnimating()
        self.centralManager.scanForPeripherals(withServices: nil)
    }
}

extension SearchErisedViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            self.searchErised()
        default:
            self.askEnableBluetooth()
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "Erised" {
            central.connect(peripheral)
            self.erisedDevice = peripheral
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let controller = AppStoryboard.Configuration.viewController(viewControllerClass: WifiSetupViewController.self)
        controller.device = peripheral
        navigationController?.pushViewController(controller, animated: true)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        askEnableBluetooth()
    }
}
