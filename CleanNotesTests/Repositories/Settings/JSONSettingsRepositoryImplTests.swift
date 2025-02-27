//
//  JSONSettingsRepositoryImplTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/02/25.
//

import XCTest
@testable import CleanNotes

class JSONSettingsRepositoryTests: XCTestCase {
    
    var sut: JSONSettingsRepositoryImpl!
    var testBundle: Bundle!

    override func setUp() {
        super.setUp()
        // Load from the test target bundle
        testBundle = Bundle(for: type(of: self))
    }

    override func tearDown() {
        sut = nil
        testBundle = nil
        super.tearDown()
    }

    func test_fetchSettings_successfullyDecodesMockJSON() {
        sut = JSONSettingsRepositoryImpl(bundle: testBundle, fileName: "MockSettings")
        let expectation = self.expectation(description: "Fetch settings completes")

        sut.fetchSettings { sections in
            XCTAssertFalse(sections.isEmpty, "Settings should not be empty")
            XCTAssertEqual(sections.first?.title, "Security")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }

    func test_fetchSettings_returnsEmptyArray_whenJSONFileIsMissing() {
        sut = JSONSettingsRepositoryImpl(bundle: testBundle, fileName: "NonExistentFile")
        let expectation = self.expectation(description: "Fetch settings completes")

        sut.fetchSettings { sections in
            XCTAssertTrue(sections.isEmpty, "Expected empty settings array when file is missing")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
    
    func test_fetchSettings_returnsEmptyArray_whenJSONFileIsInvalid() {
        sut = JSONSettingsRepositoryImpl(bundle: testBundle, fileName: "InvalidSettings")
        let expectation = self.expectation(description: "Fetch settings completes")

        sut.fetchSettings { sections in
            XCTAssertTrue(sections.isEmpty, "Expected empty settings array when file is missing")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
