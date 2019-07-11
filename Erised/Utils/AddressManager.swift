//
//  AddressManager.swift
//  Erised
//
//  Created by David Linhares on 11/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import Foundation

class AddressManager {
    static func isAddressComplete(_ address: String) -> Bool {
        let split = address.replacingOccurrences(of: " ", with: "").split(separator: "|")

        return split.count == 3
    }
}
