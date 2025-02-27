//
//  SettingsRepository.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 22/01/25.
//

protocol SettingsRepository {
    func fetchSettings(completion: @escaping ([SettingSection]) -> Void)
}

class InMemorySettingsRepositoryImpl: SettingsRepository {
    
    private var sections: [SettingSection] = []
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        populateWithSettings()
    }
    
    private func populateWithSettings() {
        let userEmail = authRepository.getCurrentUser()?.email ?? ""
        let profileSettings = [
            Setting(title: "Signed In as \(userEmail)"),
            Setting(title: "Log Out", type: .logOut)
        ]
        
        let securitySettings = [
            Setting(title: "App Lock", type: .appLock)
        ]
        
        let securitySection = SettingSection(title: "Security", settings: securitySettings)
        let profileSection = SettingSection(title: "Profile", settings: profileSettings)
        sections.append(securitySection)
        sections.append(profileSection)
    }
    
    func fetchSettings(completion: @escaping ([SettingSection]) -> Void) {
        completion(sections)
    }
}
