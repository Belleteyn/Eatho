//
//  SettingsService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 30/07/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SettingsService {
    static let instance = SettingsService()
    let defaults = UserDefaults.standard
    let activityPickerData = [
        "Minimal",
        "Light (training 3 times a week)",
        "Medium (intensive training 3 or more times a week)",
        "High (intensive training everyday)",
        "Extra (athletes)"
    ]
    
    var isConfigured: Bool {
        get {
            return defaults.bool(forKey: IS_CONFIGURED)
        }
        
        set {
            defaults.set(newValue, forKey: IS_CONFIGURED)
        }
    }
    
    var userInfo: UserInfo {
        get {
            if let data = defaults.value(forKey: USER_INFO) as? Data {
                do {
                    let info = try JSONDecoder().decode(UserInfo.self, from: data)
                    return info
                } catch let err {
                    debugPrint("reading UserInfo error: \(err)")
                }
            }
            
            return UserInfo()
        }
        
        set {
            do {
                let encodedData = try JSONEncoder().encode(newValue)
                defaults.setValue(encodedData, forKey: USER_INFO)
                isConfigured = true
                
                NotificationCenter.default.post(name: NOTIF_USER_NUTRITION_CHANGED, object: nil)
                uploadUserData(data: encodedData)
            } catch let err {
                debugPrint("writing UserInfo error: \(err)")
            }
        }
    }
    
    func uploadUserData(data: Data) {
        do {
            var json: JSON = [
                "email": AuthService.instance.userEmail,
                "token": AuthService.instance.token
            ]
            json["userData"] = try JSON(data: data)
            
            Alamofire.request(URL_USER_DATA, method: .post, parameters: json.dictionaryObject, encoding: JSONEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    print("user data uploading succeeded")
                case .failure(let err):
                    print("user data uploading failed: \(err)")
                }
            }
        } catch let err {
            debugPrint("writing UserInfo error: \(err)")
        }
    }
    
    func downloadUserData() {
        let json: JSON = [
            "email": AuthService.instance.userEmail,
            "token": AuthService.instance.token
        ]
        
        Alamofire.request(URL_SETTINGS, method: .get, parameters: json.dictionaryObject, encoding: URLEncoding.default, headers: JSON_HEADER).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        self.userInfo = try JSONDecoder().decode(UserInfo.self, from: data)
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
                    } catch let err {
                        debugPrint(err)
                    }
                }
            case .failure(let err):
                print("user data downloading failed: \(err)")
            }
        }
    }
}
