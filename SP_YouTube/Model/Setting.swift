//
//  Settings.swift
//  SP_YouTube
//
//  Created by Salvatore  Polito on 31/03/2020.
//  Copyright © 2020 Salvatore  Polito. All rights reserved.
//

import Foundation

class Setting : NSObject {
    public var name: String {get{return type.settingName}}
    public var imageName: String  {get{return type.iconName}}
    
    public let type: SettingType
    
    init(type: SettingType) {
        self.type = type
    }
}


enum SettingType : String {
    case settings = "Impostazioni"
    case privacy = "Privacy & Sicurezza"
    case feedback = "Manda un Feedback"
    case help = "Aiuto"
    case switchAccount = "Cambia Account"
    case cancel = "Annulla"
    
    public var settingName : String {
        get {
            return rawValue
        }
    }
    
    public var iconName: String {
        get {
            switch self {
            case .settings: return "settings"
            case .privacy: return "privacy"
            case .feedback: return "feedback"
            case .help: return "help"
            case .switchAccount: return "switch_account"
            case .cancel: return "cancel"
            }
        }
    }
}
