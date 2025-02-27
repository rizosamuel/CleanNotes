//
//  MockLAContext.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/02/25.
//

import LocalAuthentication

class MockLAContext: LAContext {
    var canEvaluatePolicyReturnValue: Bool = true
    var biometryTypeOverride: LABiometryType = .none
    var evaluatePolicyResult: Bool = false
    var evaluatePolicyError: NSError?

    override var biometryType: LABiometryType {
        return biometryTypeOverride
    }

    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        if !canEvaluatePolicyReturnValue {
            error?.pointee = NSError(domain: LAErrorDomain, code: LAError.biometryNotAvailable.rawValue, userInfo: nil)
        }
        return canEvaluatePolicyReturnValue
    }

    override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        reply(evaluatePolicyResult, evaluatePolicyError)
    }
}
