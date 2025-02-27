//
//  FirebaseAuthRepositoryTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

import XCTest
@testable import CleanNotes

class FirebaseAuthRepositoryTests: XCTestCase {
    
    var sut: FirebaseAuthRepositoryImpl!
    var mockUser: MockUser!
    var mockFirebaseAuth: MockFirebaseAuth!
    
    override func setUp() {
        super.setUp()
        mockUser = MockUser(uid: "mockId", email: "mockEmail@gmail.com")
        mockFirebaseAuth = MockFirebaseAuth(mockCurrentUser: mockUser)
        sut = FirebaseAuthRepositoryImpl(firebaseAuth: mockFirebaseAuth)
    }
    
    override func tearDown() {
        mockUser = nil
        mockFirebaseAuth = nil
        sut = nil
        super.tearDown()
    }
    
    func test_signup_success() {
        let expectation = self.expectation(description: "Sign up successful")
        sut.signUp(email: "mockEmail@gmail.com", password: "mockPassword") { [weak self] result in
            switch result {
            case .success(let user):
                XCTAssertTrue(self!.mockFirebaseAuth.didCreateUser)
                XCTAssertEqual(user.id, "mockId")
                XCTAssertEqual(user.email, "mockEmail@gmail.com")
            case .failure:
                XCTFail("Sign up should succeed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_signup_currentUser_isNil() {
        let expectation = self.expectation(description: "Sign up failed")
        mockFirebaseAuth.makeCurrentUserNil = true
        sut.signUp(email: "mockEmail@gmail.com", password: "mockPassword") { [weak self] result in
            switch result {
            case .success:
                XCTFail("Sign up should fail")
            case .failure(let error):
                XCTAssertTrue(self!.mockFirebaseAuth.didCreateUser)
                XCTAssertEqual(error.localizedDescription, "Current user is nil")
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_signup_failure() {
        let expectation = self.expectation(description: "Sign up failed")
        mockFirebaseAuth.mockCurrentUser = nil
        sut.signUp(email: "mockEmail@gmail.com", password: "mockPassword") { [weak self] result in
            switch result {
            case .success:
                XCTFail("Sign up should fail")
            case .failure(let error):
                XCTAssertFalse(self!.mockFirebaseAuth.didCreateUser)
                XCTAssertEqual(error.localizedDescription, "Mock sign-up error")
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_login_success() {
        let expectation = self.expectation(description: "Login successful")
        sut.login(email: "mockEmail@gmail.com", password: "mockPassword") { [weak self] result in
            switch result {
            case .success(let user):
                XCTAssertTrue(self!.sut.isLoggedIn)
                XCTAssertTrue(self!.mockFirebaseAuth.didLogin)
                XCTAssertEqual(user.id, "mockId")
                XCTAssertEqual(user.email, "mockEmail@gmail.com")
            case .failure:
                XCTFail("Login should succeed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_login_currentUser_isNil() {
        let expectation = self.expectation(description: "Login failed")
        mockFirebaseAuth.makeCurrentUserNil = true
        sut.login(email: "mockEmail@gmail.com", password: "mockPassword") { [weak self] result in
            switch result {
            case .success:
                XCTFail("Login should fail")
            case .failure(let error):
                XCTAssertTrue(self!.mockFirebaseAuth.didLogin)
                XCTAssertEqual(error.localizedDescription, "Current user is nil")
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_login_failure() {
        let expectation = self.expectation(description: "Login failed")
        mockFirebaseAuth.mockCurrentUser = nil
        sut.login(email: "mockEmail@gmail.com", password: "mockPassword") { [weak self] result in
            switch result {
            case .success:
                XCTFail("Login should fail")
            case .failure(let error):
                XCTAssertFalse(self!.mockFirebaseAuth.didCreateUser)
                XCTAssertEqual(error.localizedDescription, "Mock login error")
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_signOut() {
        sut.logout()
        XCTAssertTrue(mockFirebaseAuth.didSignOut)
        XCTAssertNil(mockFirebaseAuth.mockCurrentUser)
    }
    
    func test_currentUser_whenLoggedInUser_exists() {
        let user = sut.getCurrentUser()
        XCTAssertEqual(user?.id, mockUser.uid)
        XCTAssertEqual(user?.email, mockUser.email)
    }
    
    func test_currentUser_whenLoggedInUser_isNil() {
        mockFirebaseAuth.mockCurrentUser = nil
        let user = sut.getCurrentUser()
        XCTAssertNil(user)
    }
}
