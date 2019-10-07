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
        [NSLocalizedString("Minimal", comment: "Settings"), ""],
        [NSLocalizedString("Light", comment: ""), NSLocalizedString("training 3 times a week", comment: "")],
        [NSLocalizedString("Medium", comment: ""), NSLocalizedString("intensive training 3 or more times a week", comment: "")],
        [NSLocalizedString("High", comment: ""), NSLocalizedString("intensive training everyday", comment: "")],
        [NSLocalizedString("Extra", comment: ""), NSLocalizedString("athletes", comment: "")]
    ]
    
    var isConfigured: Bool {
        get {
            return defaults.bool(forKey: IS_CONFIGURED)
        }
        
        set {
            defaults.set(newValue, forKey: IS_CONFIGURED)
        }
    }
    
    private var _userInfo: UserInfo?
    var userInfo: UserInfo {
        get {
            if let ui = _userInfo {
                return ui
            }
            
            if let data = defaults.value(forKey: USER_INFO) as? Data {
                do {
                    let info = try JSONDecoder().decode(UserInfo.self, from: data)
                    _userInfo = info
                } catch let err {
                    debugPrint("reading UserInfo error: \(err)")
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_SYNC_ERROR, object: nil, userInfo: ["error": "decoding data error: \(err)"])
                    _userInfo = UserInfo()
                }
            } else {
                _userInfo = UserInfo()
                _userInfo?.localeLanguge = Locale.current.languageCode
            }
            
            return _userInfo!
        }
        
        set {
            do {
                let encodedData = try JSONEncoder().encode(newValue)
                defaults.setValue(encodedData, forKey: USER_INFO)
                _userInfo = newValue
                isConfigured = true
                
                NotificationCenter.default.post(name: NOTIF_USER_NUTRITION_CHANGED, object: nil)
                uploadUserData(data: encodedData)
            } catch let err {
                debugPrint("writing UserInfo error: \(err)")
                NotificationCenter.default.post(name: NOTIF_USER_DATA_SYNC_ERROR, object: nil, userInfo: ["error": "encoding data error: \(err)"])
            }
        }
    }
    
    func uploadUserData(data: Data) {
        do {
            var json: JSON = AuthService.instance.credentials
            json["userData"] = try JSON(data: data)
            
            Network.post(url: URL_USER_DATA, body: json.dictionaryObject) { (_, error) in
                if let error = error {
                    print("user data uploading failed: \(error)")
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_SYNC_ERROR, object: nil, userInfo: ["error": "uploading data error: \(error)"])
                }
            }
        } catch let err {
            debugPrint("writing UserInfo error: \(err)")
            NotificationCenter.default.post(name: NOTIF_USER_DATA_SYNC_ERROR, object: nil, userInfo: ["error": "encoding data error: \(err)"])
        }
    }
    
    func downloadUserData() {
        let json = AuthService.instance.credentials
        
        Network.get(url: URL_SETTINGS, query: json.dictionaryObject) { (response, error) in
            if let data = response?.data {
                do {
                    self.userInfo = try JSONDecoder().decode(UserInfo.self, from: data)
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
                } catch let err {
                    debugPrint(err)
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_SYNC_ERROR, object: nil, userInfo: ["error": "decoding user data error: \(err)"])
                }
            } else if let error = error {
                print("user data downloading failed: \(error)")
                NotificationCenter.default.post(name: NOTIF_USER_DATA_SYNC_ERROR, object: nil, userInfo: ["error": "downloading user data error: \(error)"])
            }
        }
    }
}
