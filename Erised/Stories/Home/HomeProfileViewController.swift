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

    var preferences: Preferences!
    private var textFieldShowed: UITextField?
    private var frameChanged =  false

    override func viewDidLoad() {
        super.viewDidLoad()
        labels.forEach {
            $0.textColor = UIColor.tertiaryColor()
        }
        fields.forEach {
            $0.attributedPlaceholder = NSAttributedString(string: $0.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryColor()])
            $0.layer.borderColor = UIColor.tertiaryColor().cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 15
            $0.delegate = self
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let field = textFieldShowed {
            if field.frame.origin.y + field.frame.height  > view.frame.height / 2 {
                view.frame.origin.y -= 80
                frameChanged = true
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if frameChanged {
            view.frame.origin.y = 0
            frameChanged = false
        }
    }
}

extension HomeProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionFlipFromBottom, animations: {
            textField.transform = CGAffineTransform(scaleX: 1, y: -1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .transitionFlipFromBottom, animations: {
                textField.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })

        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textFieldShowed = textField
        return true
    }
}
