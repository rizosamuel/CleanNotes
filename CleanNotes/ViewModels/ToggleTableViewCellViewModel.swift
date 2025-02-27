//
//  ToggleTableViewCellViewModel.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/01/25.
//

class ToggleTableViewCellViewModel {
    let setting: Setting
    let isToggleOn: Bool
    
    init(setting: Setting, isToggleOn: Bool) {
        self.setting = setting
        self.isToggleOn = isToggleOn
    }
}
