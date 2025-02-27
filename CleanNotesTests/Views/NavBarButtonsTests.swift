//
//  NavBarButtonsTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/02/25.
//

import XCTest
@testable import CleanNotes

class NavBarButtonsTests: XCTestCase {
    
    var sut: NavBarButtons!
    var mockDelegate: MockNavBarButtonsDelegate!
    
    override func setUp() {
        super.setUp()
        sut = NavBarButtons(frame: .zero)
        mockDelegate = MockNavBarButtonsDelegate()
        sut.delegate = mockDelegate
    }
    
    override func tearDown() {
        sut = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func test_init_setsUpViewCorrectly() {
        XCTAssertNotNil(sut.addButton, "Add button should be initialized")
        XCTAssertNotNil(sut.settingsButton, "Settings button should be initialized")
        XCTAssertNotNil(sut.subviews.first { $0 is UIStackView }, "StackView should be present")
    }
    
    func test_didTapAdd_callsDelegateMethod() {
        sut.addButton.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(mockDelegate.didTapAddCalled, "didTapAdd should be called when addButton is tapped")
    }
    
    func test_didTapSettings_callsDelegateMethod() {
        sut.settingsButton.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(mockDelegate.didTapSettingsCalled, "didTapSettings should be called when settingsButton is tapped")
    }
}

// MARK: - Mock Delegate
class MockNavBarButtonsDelegate: NavBarButtonsDelegate {
    var didTapAddCalled = false
    var didTapSettingsCalled = false
    
    func didTapAdd() {
        didTapAddCalled = true
    }
    
    func didTapSettings() {
        didTapSettingsCalled = true
    }
}
