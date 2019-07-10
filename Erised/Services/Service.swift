//
//  Service.swift
//  Erised
//
//  Created by David Linhares on 10/07/2019.
//  Copyright © 2019 David Linhares. All rights reserved.
//

import Foundation
import Alamofire

class Service {
    public static let baseUrl = "https://us-central1-erised-e4dae.cloudfunctions.net/"
    public static let instance = Service()

    private init() {}

    func createPreference(preference: Preferences, response: @escaping (String?) -> Void) {
        guard let data = try? JSONEncoder().encode(preference),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return
        }

        Alamofire.request("\(Service.baseUrl)createPreference", method: .post, parameters: json, encoding: JSONEncoding.default, headers: [:]).responseString {
            if let id = $0.result.value {
                response(id)
                return
            }

            response(nil)
            return
        }
    }

    func updatePreference(id: String, preference: Preferences, response: @escaping (Preferences?) -> Void) {
        guard let data = try? JSONEncoder().encode(preference),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return
        }

        Alamofire.request("\(Service.baseUrl)updPreference?id=\(id)", method: .post, parameters: json, encoding: JSONEncoding.default, headers: [:]).responseJSON {
            guard
                let data = $0.data,
                let preference = try? JSONDecoder().decode(Preferences.self, from: data) else {
                    response(nil)
                    return
            }

            response(preference)
        }
    }

    func getPreference(id: String, response: @escaping (Preferences?) -> Void) {
        Alamofire.request("\(Service.baseUrl)getPreference?id=\(id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON {
            guard
                let data = $0.data,
                let preference = try? JSONDecoder().decode(Preferences.self, from: data) else {
                    response(nil)
                    return
            }

            response(preference)
        }
    }
}
