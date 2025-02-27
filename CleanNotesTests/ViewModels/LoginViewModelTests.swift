//
//  LoginViewModelTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 21/01/25.
//

import XCTest
import Combine
@testable import CleanNotes

final class LoginViewModelTests: XCTestCase {
    
    private var sut: LoginViewModel!
    private var mockAuthRepo: MockAuthRepository!
    private var mockAuthUseCase: MockAuthUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAuthRepo = MockAuthRepository()
        mockAuthUseCase = MockAuthUseCase()
        sut = LoginViewModel(authRepo: mockAuthRepo, useCase: mockAuthUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockAuthRepo = nil
        mockAuthUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSignupSuccess() {
        mockAuthUseCase.shouldSucceed = true
        
        let expectation = self.expectation(description: "Signup should succeed")
        sut.$user.sink { user in
            if user != nil {
                XCTAssertEqual(user?.email, "test@example.com")
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.signup(email: "test@example.com", password: "password123")
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testSignupFailure() {
        mockAuthUseCase.shouldSucceed = false
        
        let expectation = self.expectation(description: "Signup should fail")
        sut.$errorMessage.sink { errorMessage in
            if errorMessage != nil {
                XCTAssertEqual(errorMessage, "Mock Error")
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.signup(email: "test@example.com", password: "password123")
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.user)
    }
    
    func testLoginSuccess() {
        mockAuthUseCase.shouldSucceed = true
        
        let expectation = self.expectation(description: "Login should succeed")
        sut.$user.sink { user in
            if user != nil {
                XCTAssertEqual(user?.email, "test@example.com")
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.login(email: "test@example.com", password: "password123")
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testLoginFailure() {
        mockAuthUseCase.shouldSucceed = false
        
        let expectation = self.expectation(description: "Login should fail")
        sut.$errorMessage.sink { errorMessage in
            if errorMessage != nil {
                XCTAssertEqual(errorMessage, "Mock Error")
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.login(email: "test@example.com", password: "password123")
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.user)
    }
}
