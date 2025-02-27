//
//  SettingsRepositoryTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 23/01/25.
//

import XCTest
@testable import CleanNotes

class SettingsRepositoryTests: XCTestCase {
    
    var sut: InMemorySettingsRepositoryImpl!
    var mockAuthRepo: MockAuthRepository!
    
    override func setUp() {
        super.setUp()
        mockAuthRepo = MockAuthRepository()
        sut = InMemorySettingsRepositoryImpl(authRepository: mockAuthRepo)
    }
    
    override func tearDown() {
        sut = nil
        mockAuthRepo = nil
        super.tearDown()
    }
    
    func testFetchSettings() {
        let expectation = self.expectation(description: "Fetch settings")
        sut.fetchSettings { settings in
            XCTAssertNotNil(settings)
            XCTAssertFalse(settings.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
}
