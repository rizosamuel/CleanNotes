//
//  LoginUseCaseTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 21/01/25.
//

import XCTest
@testable import CleanNotes

class LoginUseCaseTests: XCTestCase {
    
    var sut: LoginUseCaseImpl!
    var mockAuthRepo: MockAuthRepository!
    
    override func setUp() {
        super.setUp()
        mockAuthRepo = MockAuthRepository()
        sut = LoginUseCaseImpl(authRepository: mockAuthRepo)
    }
    
    override func tearDown() {
        mockAuthRepo = nil
        sut = nil
        super.tearDown()
    }
    
    func test_login_success() {
        let expectation = self.expectation(description: "Login successful")
        mockAuthRepo.setupFor(.success)
        sut.executeLogin(email: "mockEmail@email.com", password: "mockPassword") { [weak self] result in
            switch result {
            case .success(let user):
                XCTAssertTrue(self!.mockAuthRepo.didLogin)
                XCTAssertEqual(user.id, "mockId")
                XCTAssertEqual(user.email, "mockEmail@email.com")
            case .failure:
                XCTFail("Login should succeed")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_login_failure() {
        let expectation = self.expectation(description: "Login failure")
        mockAuthRepo.setupFor(.failure)
        sut.executeLogin(email: "mockEmail@email.com", password: "mockPassword") { [weak self] result in
            switch result {
            case .success:
                XCTFail("Login should fail")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "Mock login/signup error")
                XCTAssertFalse(self!.mockAuthRepo.didLogin)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
