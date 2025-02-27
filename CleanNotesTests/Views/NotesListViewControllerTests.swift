//
//  NotesListViewControllerTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import XCTest
@testable import CleanNotes

class NotesListViewControllerTests: XCTestCase {
    
    var sut: NotesListViewController!
    var mockAuthRepo: MockAuthRepository!
    var mockNotesRepo: MockNotesRepository!
    var mockViewModel: MockNotesListViewModel!
    var mockRouter: MockNotesRouter!
    
    override func setUp() {
        super.setUp()
        mockAuthRepo = MockAuthRepository()
        mockNotesRepo = MockNotesRepository()
        mockViewModel = MockNotesListViewModel(authRepo: mockAuthRepo, notesRepo: mockNotesRepo)
        mockRouter = MockNotesRouter()
        sut = NotesListViewController(viewModel: mockViewModel, router: mockRouter)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        mockAuthRepo = nil
        mockNotesRepo = nil
        mockViewModel = nil
        mockRouter = nil
        sut = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_setsUpUI() {
        XCTAssertEqual(sut.title, "Notes", "The navigation title should be 'Notes'.")
        let tableView = getTableView()
        XCTAssertNotNil(sut.view.subviews.contains(tableView), "The table view should be added to the view hierarchy.")
        XCTAssertEqual(tableView.dataSource as? NotesListViewController, sut, "The table view's data source should be the view controller.")
    }
    
    func test_viewDidAppear_whenUserLoggedIn() {
        mockAuthRepo.isLoggedIn = true
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        XCTAssertFalse(mockRouter.didPresentAuthVC)
    }
    
    func test_viewDidAppear_whenUserNotLoggedIn() {
        mockAuthRepo.isLoggedIn = false
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        XCTAssertTrue(mockRouter.didPresentAuthVC)
    }
    
    func test_addButton_action() {
        sut.didTapAdd()
        XCTAssertTrue(mockRouter.didNavigateToCreateNoteVC)
    }
    
    func test_gearButton_action() {
        sut.didTapSettings()
        XCTAssertTrue(mockRouter.didNavigateToSettingsVC)
    }
    
    func test_tableView_dataSource_updates() {
        mockViewModel.mockNotes = [
            Note(id: UUID(), title: "Note 1", content: "Content 1", timeStamp: Date()),
            Note(id: UUID(), title: "Note 2", content: "Content 2", timeStamp: Date())
        ]
        let tableView = getTableView()
        tableView.reloadData()
        let rows = tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(mockViewModel.mockNotes.count, rows)
    }
    
    func test_tableView_cellForRowAt() {
        let mockNotes = [
            Note(id: UUID(), title: "Note 1", content: "Content 1", timeStamp: Date()),
            Note(id: UUID(), title: "Note 2", content: "Content 2", timeStamp: Date())
        ]
        mockViewModel.mockNotes = mockNotes
        let tableView = getTableView()
        tableView.reloadData()
        let cell = tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertNotNil(cell, "The cell should not be nil.")
        if let config = cell?.contentConfiguration as? UIListContentConfiguration {
            XCTAssertEqual(config.text, "Note 1", "The cell's text should match the note's title.")
        } else {
            XCTFail("The cell's contentConfiguration should be a UIListContentConfiguration.")
        }
    }
    
    func test_tableView_didSelectRow_navigatesToNote() {
        let note = Note(id: UUID(), title: "Sample Note", content: "Sample Content", timeStamp: Date())
        mockViewModel.mockNotes = [note]
        let tableView = getTableView()
        tableView.reloadData()
        tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(mockRouter.capturedNote?.title, note.title, "The router should navigate to the correct note.")
    }
    
    func test_didCreateNote_delegate() {
        let note = Note(id: UUID(), title: "Sample Note", content: "Sample Content", timeStamp: Date())
        sut.didCreateNote(with: note)
        
        XCTAssertTrue(mockViewModel.didFetchNotes)
    }
    
    func test_didLogin_delegate() {
        sut.didLogin()
        
        XCTAssertTrue(mockViewModel.didFetchNotes)
    }
    
    private func getTableView() -> UITableView {
        guard let tableView = sut.view.subviews.compactMap ({ $0 as? UITableView }).first else {
            fatalError("TableView is not setup in sut view")
        }
        return tableView
    }
}
