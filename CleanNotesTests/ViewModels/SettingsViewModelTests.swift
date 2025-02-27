//
//  SettingsViewModelTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 23/01/25.
//

import XCTest
@testable import CleanNotes

class SettingsViewModelTests: XCTestCase {
    
    var sut: SettingsViewModel!
    var mockAuthRepo: MockAuthRepository!
    var mockUseCase: MockSettingsUseCase!
    var mockBiometricsUsecase: MockBiometricsUseCase!
    var mockUserDefaultsRepo: MockUserDefaultsRepository!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockSettingsUseCase()
        mockAuthRepo = MockAuthRepository()
        mockBiometricsUsecase = MockBiometricsUseCase()
        mockUserDefaultsRepo = MockUserDefaultsRepository()
        
        sut = SettingsViewModel(
            useCase: mockUseCase,
            authRepo: mockAuthRepo,
            biometricsUseCase: mockBiometricsUsecase,
            userDefaultsRepo: mockUserDefaultsRepo
        )
    }
    
    override func tearDown() {
        sut = nil
        mockAuthRepo = nil
        mockUseCase = nil
        mockBiometricsUsecase = nil
        mockUserDefaultsRepo = nil
        super.tearDown()
    }
    
    func test_fetchSettings() {
        let expectation = self.expectation(description: "Fetch Settings Successful")
        sut.fetchSettings { [weak self] in
            XCTAssertEqual(self?.sut.sections.count, 1)
            XCTAssertEqual(self?.sut.sections.first?.title, "mock section")
            XCTAssertEqual(self?.sut.sections.first?.settings.first?.title, "mock setting")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_logout() {
        sut.logOut()
        XCTAssertTrue(mockAuthRepo.didLogout)
    }
}
