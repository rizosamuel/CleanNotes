//
//  BiometricsUseCaseTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/02/25.
//

import XCTest
@testable import CleanNotes

class BiometricsUseCaseTests: XCTestCase {
    
    var sut: BiometricsUseCaseImpl!
    var mockBiometricsRepository: MockBiometricsRepository!
    var mockUserDefaultsRepository: MockUserDefaultsRepository!

    override func setUp() {
        super.setUp()
        mockBiometricsRepository = MockBiometricsRepository()
        mockUserDefaultsRepository = MockUserDefaultsRepository()
        sut = BiometricsUseCaseImpl(biometricsRepo: mockBiometricsRepository, userDefaultsRepo: mockUserDefaultsRepository)
    }

    override func tearDown() {
        sut = nil
        mockBiometricsRepository = nil
        mockUserDefaultsRepository = nil
        super.tearDown()
    }
    
    func test_isBiometricsAvailable_returnsCorrectValue() {
        mockBiometricsRepository.isBiometricsAvailable = true
        let result = sut.isBiometricsAvailable
        XCTAssertTrue(result)
    }
    
    func test_biometryErrorReason_returnsCorrectValue() {
        mockBiometricsRepository.biometryErrorReason = "Biometry is locked out"
        let result = sut.biometryErrorReason
        XCTAssertEqual(result, "Biometry is locked out")
    }
    
    func test_authenticate_callsRepositoryAuthenticate() {
        var completionCalled = false
        mockBiometricsRepository.shouldAuthenticateSucceed = true
        
        sut.authenticate { success, error in
            completionCalled = true
            XCTAssertTrue(success)
            XCTAssertEqual(error, "")
        }
        
        XCTAssertTrue(completionCalled)
        XCTAssertTrue(mockBiometricsRepository.authenticateCalled)
    }
}
