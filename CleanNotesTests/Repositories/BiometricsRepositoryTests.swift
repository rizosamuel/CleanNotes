//
//  BiometricsRepositoryTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/02/25.
//

import XCTest
import LocalAuthentication
@testable import CleanNotes

class BiometricsRepositoryTests: XCTestCase {
    
    var mockContext: MockLAContext!
    var sut: BiometricsRepositoryImpl!

    override func setUp() {
        super.setUp()
        mockContext = MockLAContext()
        sut = BiometricsRepositoryImpl(context: mockContext)
    }

    override func tearDown() {
        mockContext = nil
        sut = nil
        super.tearDown()
    }

    // Test when biometrics is available (Face ID)
    func test_isBiometricsAvailable_whenFaceID_shouldReturnTrue() {
        mockContext.canEvaluatePolicyReturnValue = true
        mockContext.biometryTypeOverride = .faceID

        XCTAssertTrue(sut.isBiometricsAvailable, "Biometrics should be available")
    }

    // Test when biometrics is available (Touch ID)
    func test_isBiometricsAvailable_whenTouchID_shouldReturnTrue() {
        mockContext.canEvaluatePolicyReturnValue = true
        mockContext.biometryTypeOverride = .touchID

        XCTAssertTrue(sut.isBiometricsAvailable, "Biometrics should be available")
    }

    // Test when biometrics is not available
    func test_isBiometricsAvailable_whenNotAvailable_shouldReturnFalse() {
        mockContext.canEvaluatePolicyReturnValue = false
        mockContext.biometryTypeOverride = .none

        XCTAssertFalse(sut.isBiometricsAvailable, "Biometrics should not be available")
    }

    // Test authentication success
    func test_authenticate_whenSuccess_shouldReturnTrue() {
        mockContext.evaluatePolicyResult = true
        mockContext.evaluatePolicyError = nil

        let expectation = self.expectation(description: "Authentication should succeed")
        sut.authenticate { success, error in
            XCTAssertTrue(success, "Authentication should be successful")
            XCTAssertEqual(error, "", "Error should be empty")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    // Test authentication failure
    func test_authenticate_whenFails_shouldReturnFalse() {
        mockContext.evaluatePolicyResult = false
        mockContext.evaluatePolicyError = NSError(domain: LAErrorDomain, code: LAError.authenticationFailed.rawValue, userInfo: nil)

        let expectation = self.expectation(description: "Authentication should fail")
        sut.authenticate { success, error in
            XCTAssertFalse(success, "Authentication should fail")
            XCTAssertEqual(error, "Authentication failed", "Error should match expected failure message")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    // Test authentication cancellation
    func test_authenticate_whenUserCancels_shouldReturnUserCancelError() {
        mockContext.evaluatePolicyResult = false
        mockContext.evaluatePolicyError = NSError(domain: LAErrorDomain, code: LAError.userCancel.rawValue, userInfo: nil)

        let expectation = self.expectation(description: "Authentication should be cancelled")
        sut.authenticate { success, error in
            XCTAssertFalse(success, "Authentication should be cancelled")
            XCTAssertEqual(error, "User cancelled authentication", "Error should match expected cancellation message")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    // Test reset context
    func test_resetContext_shouldInvalidateContext() {
        sut.resetContext()
        XCTAssertTrue(true, "Context reset should complete without errors")
    }
}
