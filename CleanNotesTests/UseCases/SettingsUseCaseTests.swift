//
//  SettingsUseCaseTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 23/01/25.
//

import XCTest
@testable import CleanNotes

class SettingsUseCaseTests: XCTestCase {
    
    var sut: SettingsUseCaseImpl!
    var mockRepository: MockSettingsRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockSettingsRepository()
        sut = SettingsUseCaseImpl(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_fetchSettings() {
        let expectation = self.expectation(description: "Fetch Settings Successful")
        sut.execute { sections in
            XCTAssertNotNil(sections)
            XCTAssertEqual(sections.count, 1)
            XCTAssertEqual(sections.first?.title, "mock section")
            XCTAssertEqual(sections.first?.settings.first?.title, "mock setting")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
