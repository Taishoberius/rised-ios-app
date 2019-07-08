//
//  AppFileManager.swift
//  Erised
//
//  Created by David Linhares on 07/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import Foundation

enum AppFileManager: String {
    case Config
    case Preferences

    func getFileContent() -> String {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let file = dir.appendingPathComponent(self.rawValue)
            do {
                return try String(contentsOf: file)
            } catch {

            }
        }

        return ""
    }

    func write(_ string: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let file = dir.appendingPathComponent(self.rawValue)
            do {
                return try string.write(to: file, atomically: true, encoding: .utf8)
            } catch {

            }
        }
    }
}
