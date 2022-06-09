//
//  BiometricAuth.swift
//  FanChatApp
//
//  Created by max on 02.06.2022.
//

import Foundation
import LocalAuthentication

class BiometricAuth {
    let context = LAContext()
    var loginReason = "Logging in with "
    
    enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func biometricType() -> BiometricType {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .touchID:
//            loginReason = loginReason
            return .touchID
        case .faceID:
//            loginReason = loginReason
            return .faceID
        default:
            return .none
        }
    }
    
    func authentificateUser(completion: @escaping (String?) -> Void) {
        guard canEvaluatePolicy() else {
            completion("Biometric auth is not availiable")
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { success, error in
            if success {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else {
                let message: String
                
                switch error {
                case LAError.authenticationFailed?:
                    message = "Identity not verified"
                case LAError.userCancel?:
                    message = "User is cancelled"
                case LAError.userFallback?:
                    message = "User choose to use password"
                case LAError.biometryNotAvailable?:
                    message = "Face ID/ Touch ID is not availiable"
                case LAError.biometryNotEnrolled?:
                    message = "Face ID/ Touch ID is not enrolled on device"
                case LAError.biometryLockout?:
                    message = "Face ID/ Touch ID is locked out on device"
                default:
                    message = "Face ID/ Touch ID may not be configured"
                }
                DispatchQueue.main.async {
                    completion(message)
                }
            }
        }
    }
}
