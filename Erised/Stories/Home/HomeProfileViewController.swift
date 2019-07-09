//
//  HomeProfileViewController.swift
//  Erised
//
//  Created by David Linhares on 09/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import UIKit

class HomeProfileViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var homeAddress: UITextField!
    @IBOutlet weak var homeZipcode: UITextField!
    @IBOutlet weak var homeCity: UITextField!
    @IBOutlet weak var workAddress: UITextField!
    @IBOutlet weak var workZipcode: UITextField!
    @IBOutlet weak var workCity: UITextField!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var fields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        labels.forEach {
            $0.textColor = UIColor.tertiaryColor()
        }
        fields.forEach {
            $0.attributedPlaceholder = NSAttributedString(string: $0.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryColor()])
            $0.layer.borderColor = UIColor.secondaryColor().cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 15
        }
    }
}
