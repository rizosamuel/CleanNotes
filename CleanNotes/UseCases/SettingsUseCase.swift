//
//  SettingsUseCase.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 22/01/25.
//

protocol SettingsUseCase {
    func execute(completion: @escaping ([SettingSection]) -> Void)
}

final class SettingsUseCaseImpl: SettingsUseCase {
    private let repository: SettingsRepository
    
    init(repository: SettingsRepository) {
        self.repository = repository
    }
    
    func execute(completion: @escaping ([SettingSection]) -> Void) {
        repository.fetchSettings(completion: completion)
    }
}
