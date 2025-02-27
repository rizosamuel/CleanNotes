//
//  BiometricsUseCase.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/01/25.
//

protocol BiometricsUseCase {
    var isBiometricsAvailable: Bool { get }
    var biometryErrorReason: String { get }
    func authenticate(completion: @escaping (Bool, String) -> Void)
}

class BiometricsUseCaseImpl: BiometricsUseCase {
    
    private let biometricsRepository: BiometricsRepository
    private let userDefaultsRepository: UserDefaultsRepository
    
    init(biometricsRepo: BiometricsRepository, userDefaultsRepo: UserDefaultsRepository) {
        self.biometricsRepository = biometricsRepo
        self.userDefaultsRepository = userDefaultsRepo
    }
    
    var biometryErrorReason: String {
        biometricsRepository.biometryErrorReason
    }
    
    var isBiometricsAvailable: Bool {
        biometricsRepository.isBiometricsAvailable
    }
    
    func authenticate(completion: @escaping (Bool, String) -> Void) {
        biometricsRepository.authenticate(completion: completion)
    }
}
