//
//  ToggleTableViewCellTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/02/25.
//

import XCTest
@testable import CleanNotes

class ToggleTableViewCellTests: XCTestCase {
    
    var sut: ToggleTableViewCell!
    var mockDelegate: MockToggleTableViewCellDelegate!
    var mockSetting: Setting!
    var mockViewModel: ToggleTableViewCellViewModel!
    
    override func setUp() {
        super.setUp()
        sut = ToggleTableViewCell(style: .default, reuseIdentifier: ToggleTableViewCell.identifier)
        mockDelegate = MockToggleTableViewCellDelegate()
        sut.delegate = mockDelegate
        mockSetting = Setting(title: "Mock Setting") // Adjust based on your Setting model
        mockViewModel = ToggleTableViewCellViewModel(setting: mockSetting, isToggleOn: true)
    }
    
    override func tearDown() {
        sut = nil
        mockDelegate = nil
        mockSetting = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    func test_cellInitializesCorrectly() {
        XCTAssertNotNil(sut)
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.toggle)
    }
    
    func test_prepareForReuse_resetsCellProperties() {
        sut.titleLabel.text = "Test"
        sut.toggle.isHidden = false
        sut.prepareForReuse()
        
        XCTAssertNil(sut.titleLabel.text, "Title label should be reset")
        XCTAssertFalse(sut.toggle.isOn, "Toggle should be disabled after reuse")
    }
    
    func test_configure_updatesUIElements() {
        sut.configure(with: mockViewModel)
        
        XCTAssertEqual(sut.titleLabel.text, mockViewModel.setting.title)
        XCTAssertEqual(sut.toggle.isOn, mockViewModel.isToggleOn)
    }
    
    func test_toggleValueChange_callsDelegate() {
        sut.configure(with: mockViewModel)
        
        sut.toggle.isOn = false
        sut.toggle.sendActions(for: .valueChanged) // Simulating user toggle action
        
        XCTAssertTrue(mockDelegate.didToggleCalled, "Delegate method should be called on toggle change")
        XCTAssertEqual(mockDelegate.receivedSetting?.title, mockSetting.title, "Correct setting should be passed")
        XCTAssertEqual(mockDelegate.receivedToggleState, false, "Toggle state should be passed correctly")
    }
}

// MARK: - Mock Delegate
class MockToggleTableViewCellDelegate: ToggleTableViewCellDelegate {
    var didToggleCalled = false
    var receivedSetting: Setting?
    var receivedToggleState: Bool?
    
    func didToggle(on setting: Setting, _ toggle: UISwitch) {
        didToggleCalled = true
        receivedSetting = setting
        receivedToggleState = toggle.isOn
    }
}
