//
//  SettingsViewModel.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 22/01/25.
//

class SettingsViewModel {
    
    private let useCase: SettingsUseCase
    private let authRepository: AuthRepository
    private let biometricsUseCase: BiometricsUseCase
    private let userDefaultsRepo: UserDefaultsRepository
    var sections: [SettingSection] = []
    
    init(
        useCase: SettingsUseCase,
        authRepo: AuthRepository,
        biometricsUseCase: BiometricsUseCase,
        userDefaultsRepo: UserDefaultsRepository
    ) {
        self.useCase = useCase
        self.authRepository = authRepo
        self.biometricsUseCase = biometricsUseCase
        self.userDefaultsRepo = userDefaultsRepo
    }
    
    func fetchSettings(completion: @escaping () -> Void) {
        useCase.execute { [weak self] settings in
            self?.sections = settings
            completion()
        }
    }
    
    var isBiometricsAvailable: Bool {
        return biometricsUseCase.isBiometricsAvailable
    }
    
    var biometryErrorReason: String {
        return biometricsUseCase.biometryErrorReason
    }
    
    var isAppLockEnabled: Bool {
        guard let isAppLockEnabled = userDefaultsRepo.get(forKey: Constants.IS_APP_LOCK_KEY, type: Bool.self) else { return false }
        return isAppLockEnabled
    }
    
    func authenticate(completion: @escaping (Bool, String) -> Void) {
        biometricsUseCase.authenticate { isSuccess, error in
            completion(isSuccess, error)
        }
    }
    
    func setAppLockEnabled(_ isEnabled: Bool) {
        userDefaultsRepo.save(isEnabled, forKey: Constants.IS_APP_LOCK_KEY)
    }
    
    func logOut() {
        authRepository.logout()
    }
}
