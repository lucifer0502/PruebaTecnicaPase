//
//  authenticateUser.swift
//  PruebaTecnicaPase
//
//  Created by Fernando Flores on 24/10/25.
//

import LocalAuthentication

final class BiometricAuthenticator {
    
    static func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        context.localizedCancelTitle = "Cancelar"
        context.localizedFallbackTitle = "Usar contraseña"
        
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: "Accede a los detalles del personaje") { success, evaluateError in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            completion(false)
        }
    }
}
