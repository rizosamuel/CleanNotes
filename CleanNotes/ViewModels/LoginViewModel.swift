//
//  LoginViewModel.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

import Foundation
import Combine

final class LoginViewModel {
    
    @Published var isLoading: Bool = false
    @Published var user: User?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let isLoggedIn: Bool
    private let authUseCase: AuthUseCase
    
    init(authRepo: AuthRepository, useCase: AuthUseCase) {
        self.authUseCase = useCase
        self.isLoggedIn = authRepo.isLoggedIn
    }
    
    func signup(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        authUseCase.executeSignup(email: email, password: password) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let user):
                self?.user = user
                print("Login successful for user: \(user.email ?? "Unknown email")")
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        authUseCase.executeLogin(email: email, password: password) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let user):
                self?.user = user
                print("Login successful for user: \(user.email ?? "Unknown email")")
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                print("Login failed: \(error.localizedDescription)")
            }
        }
    }
}
