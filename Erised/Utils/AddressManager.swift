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
        let split = address.components(separatedBy: "|")

        return split.count == 3
    }

    static func getAddress(_ address: String) -> String {
        let split = address.components(separatedBy: "|")

        if split.count > 0 {
            return split[0].description
        }

        return ""
    }

    static func getZipCode(_ address: String) -> String {
        let split = address.components(separatedBy: "|")

        if split.count > 1 {
            return split[1].description
        }

        return ""
    }

    static func getCity(_ address: String) -> String {
        let split = address.components(separatedBy: "|")

        if split.count > 2 {
            return split[2].description
        }

        return ""
    }
}
