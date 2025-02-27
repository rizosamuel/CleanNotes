//
//  SignupUseCaseTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 21/01/25.
//

import XCTest
@testable import CleanNotes

class SignupUseCaseTests: XCTestCase {
    
    var sut: SignUpUseCaseImpl!
    var mockAuthRepo: MockAuthRepository!
    
    override func setUp() {
        super.setUp()
        mockAuthRepo = MockAuthRepository()
        sut = SignUpUseCaseImpl(authRepository: mockAuthRepo)
    }
    
    override func tearDown() {
        mockAuthRepo = nil
        sut = nil
        super.tearDown()
    }
    
    func test_signup_success() {
        let expectation = self.expectation(description: "Signup successful")
        mockAuthRepo.setupFor(.success)
        sut.executeSignup(email: "mockEmail@email.com", password: "mockPassword") { [weak self] result in
            switch result {
            case .success(let user):
                XCTAssertTrue(self!.mockAuthRepo.didSignUp)
                XCTAssertEqual(user.id, "mockId")
                XCTAssertEqual(user.email, "mockEmail@email.com")
            case .failure:
                XCTFail("Sign up should succeed")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_signup_failure() {
        let expectation = self.expectation(description: "Signup failure")
        mockAuthRepo.setupFor(.failure)
        sut.executeSignup(email: "mockEmail@email.com", password: "mockPassword") { [weak self] result in
            switch result {
            case .success:
                XCTFail("Sign up should fail")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "Mock login/signup error")
                XCTAssertFalse(self!.mockAuthRepo.didSignUp)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
