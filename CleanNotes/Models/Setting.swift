//
//  Setting.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 22/01/25.
//

struct SettingSection: Codable {
    let title: String
    let settings: [Setting]
}

enum SettingType: String, Codable {
    case logOut, appLock
}

struct Setting: Codable {
    let title: String
    let type: SettingType?
    
    
    init(title: String, type: SettingType? = nil) {
        self.title = title
        self.type = type
    }
}
