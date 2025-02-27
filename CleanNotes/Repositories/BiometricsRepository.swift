//
//  BiometricsRepository.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/01/25.
//

import LocalAuthentication

protocol BiometricsRepository {
    var isBiometricsAvailable: Bool { get }
    var biometryErrorReason: String { get }
    func authenticate(completion: @escaping (Bool, String) -> Void)
}

enum BiometryType: String {
    case none, touchId, faceId, unknown
}

class BiometricsRepositoryImpl: BiometricsRepository, FileIdentifier {
    private let context: LAContext
    private var biometryError: NSError?
    private var currentBiometryType: BiometryType = .none
    private let contextQueue = DispatchQueue(label: "com.myapp.biometricQueue")
    
    var biometryErrorReason: String = ""
    
    init(context: LAContext) {
        self.context = context
    }
    
    var isBiometricsAvailable: Bool {
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &biometryError) else {
            biometryErrorReason = getAuthenticationError()
            print("\n[\(fileName)] BIOMETRICS IS NOT AVAILABLE \(biometryErrorReason))")
            currentBiometryType = .none
            return false
        }
        
        switch context.biometryType {
        case .faceID:
            currentBiometryType = .faceId
        case .touchID:
            currentBiometryType = .touchId
        default:
            currentBiometryType = .unknown
        }
        print("\n[\(fileName)] \(currentBiometryType.rawValue.uppercased()) BIOMETRICS IS AVAILABLE")
        return true
    }
    
    private func getAuthenticationError() -> String {
        guard let laError = biometryError as? LAError else { return "" }
        
        switch laError.code {
        case .authenticationFailed:
            return "Authentication failed"
        case .userCancel:
            return "User cancelled authentication"
        case .userFallback:
            return "User chose password instead"
        case .biometryNotAvailable:
            return "Biometry not available on this device"
        case .biometryNotEnrolled:
            return "User has not enrolled biometric authentication"
        case .biometryLockout:
            return "Biometry is locked out. Use passcode"
        default:
            return "Unknown error: \(laError.localizedDescription)"
        }
    }
    
    func authenticate(completion: @escaping (Bool, String) -> Void) {
        contextQueue.async { [weak self] in
            let reason = "Authenticate to access your data"
            self?.context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.biometryError = error as? NSError
                    self.biometryErrorReason = self.getAuthenticationError()
                    completion(success, self.biometryErrorReason)
                }
            }
        }
    }
    
    func resetContext() {
        context.invalidate()
    }
}
