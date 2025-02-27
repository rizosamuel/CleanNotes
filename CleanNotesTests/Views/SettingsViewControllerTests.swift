//
//  SettingsViewControllerTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 23/01/25.
//

import XCTest
@testable import CleanNotes

class SettingsViewControllerTests: XCTestCase {
    
    var sut: SettingsViewController!
    var mockAuthRepo: MockAuthRepository!
    var mockUseCase: MockSettingsUseCase!
    var mockbiometricsUseCase: MockBiometricsUseCase!
    var mockUserDefaultsRepo: MockUserDefaultsRepository!
    var mockViewModel: MockSettingsViewModel!
    var mockRouter: MockNotesRouter!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockSettingsUseCase()
        mockAuthRepo = MockAuthRepository()
        mockbiometricsUseCase = MockBiometricsUseCase()
        mockUserDefaultsRepo = MockUserDefaultsRepository()
        mockViewModel = MockSettingsViewModel(
            useCase: mockUseCase,
            authRepo: mockAuthRepo,
            biometricsUseCase: mockbiometricsUseCase,
            userDefaultsRepo: mockUserDefaultsRepo
        )
        mockRouter = MockNotesRouter()
        sut = SettingsViewController(viewModel: mockViewModel, router: mockRouter)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        mockAuthRepo = nil
        mockUseCase = nil
        mockbiometricsUseCase = nil
        mockUserDefaultsRepo = nil
        mockViewModel = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_setsUpUI() {
        XCTAssertEqual(sut.title, "Settings", "The navigation title should be 'Settings'.")
        let tableView = getTableView()
        XCTAssertNotNil(sut.view.subviews.contains(tableView), "The table view should be added to the view hierarchy.")
        XCTAssertEqual(tableView.dataSource as? SettingsViewController, sut, "The table view's data source should be the view controller.")
    }
    
    private func getTableView() -> UITableView {
        guard let tableView = sut.view.subviews.compactMap ({ $0 as? UITableView }).first else {
            fatalError("TableView is not setup in sut view")
        }
        return tableView
    }
    
    func test_tableView_dataSource_updates() {
        mockViewModel.mockSections = [
            SettingSection(title: "mock section", settings: [Setting(title: "mock setting", type: .appLock)])
        ]
        let tableView = getTableView()
        tableView.reloadData()
        let rows = tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(mockViewModel.mockSections.count, rows)
    }
    
    func test_tableView_cellForRowAt_withSettingType_appLock() {
        let mockSections = [
            SettingSection(title: "mock section", settings: [Setting(title: "mock app lock setting", type: .appLock)])
        ]
        mockViewModel.mockSections = mockSections
        let tableView = getTableView()
        tableView.reloadData()
        let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(cell, "The cell should not be nil.")
        XCTAssertTrue(cell is ToggleTableViewCell)
    }
    
    func test_tableView_cellForRowAt_withSettingType_logOut() {
        let mockSections = [
            SettingSection(title: "mock section", settings: [Setting(title: "mock log out setting", type: .logOut)])
        ]
        mockViewModel.mockSections = mockSections
        let tableView = getTableView()
        tableView.reloadData()
        let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(cell, "The cell should not be nil.")
        if let config = cell?.contentConfiguration as? UIListContentConfiguration {
            XCTAssertEqual(config.text, "mock log out setting")
        } else {
            XCTFail("Cell should have a UIListContentConfiguration")
        }
    }
    
    func test_tableView_didSelectRow_performsAction() {
        let section = SettingSection(title: "mock section", settings: [Setting(title: "mock logout setting", type: .logOut)])
        mockViewModel.mockSections = [section]
        let tableView = getTableView()
        tableView.reloadData()

        tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(mockViewModel.sections.first?.settings.first?.type, SettingType.logOut)
    }
    
    func test_tableView_toggleCell_toggleOff_whenBiometricsFailure() {
        let mockSections = [
            SettingSection(title: "mock section", settings: [Setting(title: "mock app lock setting", type: .appLock)])
        ]
        mockViewModel.mockSections = mockSections
        let tableView = getTableView()
        tableView.reloadData()
        
        let dummyToggle = UISwitch()
        dummyToggle.isOn = false
        sut.didToggle(on: mockSections[0].settings[0], dummyToggle)
        XCTAssertTrue(mockViewModel.isAppLockEnabled)
    }
    
    func test_tableView_toggleCell_toggleOn_whenBiometricsFailure() {
        let mockSections = [
            SettingSection(title: "mock section", settings: [Setting(title: "mock app lock setting", type: .appLock)])
        ]
        mockViewModel.mockSections = mockSections
        let tableView = getTableView()
        tableView.reloadData()
        
        let dummyToggle = UISwitch()
        dummyToggle.isOn = true
        sut.didToggle(on: mockSections[0].settings[0], dummyToggle)
        XCTAssertFalse(mockViewModel.isAppLockEnabled)
    }
    
    func test_tableView_toggleCell_toggleOff_whenBiometricsSuccess() {
        let mockSections = [
            SettingSection(title: "mock section", settings: [Setting(title: "mock app lock setting", type: .appLock)])
        ]
        mockViewModel.mockSections = mockSections
        let tableView = getTableView()
        tableView.reloadData()
        
        let dummyToggle = UISwitch()
        dummyToggle.isOn = false
        mockbiometricsUseCase.isAuthenticated = true
        sut.didToggle(on: mockSections[0].settings[0], dummyToggle)
        XCTAssertFalse(mockViewModel.isAppLockEnabled)
    }
    
    func test_tableView_toggleCell_toggleOn_whenBiometricsSuccess() {
        let mockSections = [
            SettingSection(title: "mock section", settings: [Setting(title: "mock app lock setting", type: .appLock)])
        ]
        mockViewModel.mockSections = mockSections
        let tableView = getTableView()
        tableView.reloadData()
        
        let dummyToggle = UISwitch()
        dummyToggle.isOn = true
        mockbiometricsUseCase.isAuthenticated = true
        sut.didToggle(on: mockSections[0].settings[0], dummyToggle)
        XCTAssertTrue(mockViewModel.isAppLockEnabled)
    }
    
    func test_tableView_toggleCell_toggleOff_whenBiometricsNotAvailable() {
        let mockSections = [
            SettingSection(title: "mock section", settings: [Setting(title: "mock app lock setting", type: .appLock)])
        ]
        mockViewModel.mockSections = mockSections
        let tableView = getTableView()
        tableView.reloadData()
        
        let dummyToggle = UISwitch()
        dummyToggle.isOn = false
        mockbiometricsUseCase.isBiometricsAvailable = false
        sut.didToggle(on: mockSections[0].settings[0], dummyToggle)
        XCTAssertFalse(mockViewModel.isAppLockEnabled)
    }
}
