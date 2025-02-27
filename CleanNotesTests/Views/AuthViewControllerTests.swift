//
//  AuthViewControllerTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 22/01/25.
//

import XCTest
@testable import CleanNotes

class AuthViewControllerTests: XCTestCase {
    
    var sut: AuthViewController!
    var mockAuthRepo: MockAuthRepository!
    var mockUseCase: MockAuthUseCase!
    var mockViewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        mockAuthRepo = MockAuthRepository()
        mockUseCase = MockAuthUseCase()
        mockViewModel = LoginViewModel(authRepo: mockAuthRepo, useCase: mockUseCase)
        sut = AuthViewController(viewModel: mockViewModel)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        mockViewModel = nil
        mockUseCase = nil
        mockAuthRepo = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_setsUpUI() {
        XCTAssertEqual(sut.title, "Login/Sign Up", "The navigation title should be 'Login/Sign Up'")
    }
    
    func testLoginButtonAction() {
        sut.emailTextField.text = "test@example.com"
        sut.passwordTextField.text = "password123"
        
        sut.loginButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockViewModel.user?.email, "test@example.com")
        XCTAssertEqual(mockViewModel.user?.id, "mockId")
    }
    
    func testSignUpButtonAction() {
        sut.emailTextField.text = "newuser@example.com"
        sut.passwordTextField.text = "newpassword123"

        sut.signupButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(mockViewModel.user?.email, "newuser@example.com")
        XCTAssertEqual(mockViewModel.user?.id, "mockId")
    }
}
