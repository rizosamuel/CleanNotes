//
//  CreateNoteViewControllerTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import XCTest
@testable import CleanNotes

class CreateNoteViewControllerTests: XCTestCase {
    
    var sut: CreateNoteViewController!
    var mockUseCase: MockCreateNoteUseCase!
    var mockViewModel: CreateNoteViewModel!
    var mockRouter: MockNotesRouter!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockCreateNoteUseCase()
        mockViewModel = CreateNoteViewModel(useCase: mockUseCase)
        mockRouter = MockNotesRouter()
        sut = CreateNoteViewController(viewModel: mockViewModel, router: mockRouter)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        mockRouter = nil
        mockViewModel = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_setsUpUI() {
        XCTAssertEqual(sut.title, "Add a new note")
        XCTAssertTrue(sut.view.subviews.contains(sut.textField))
        XCTAssertTrue(sut.view.subviews.contains(sut.textView))
    }
    
    func test_closeButton_action() {
        let closeButton = sut.navigationItem.leftBarButtonItem
        _ = closeButton?.target?.perform(closeButton?.action, with: nil)
        
        XCTAssertTrue(mockRouter.didDismiss)
    }
    
    func test_saveButton_action_withInput() {
        let note = Note(id: UUID(), title: "Sample Note", content: "This is a test note", timeStamp: Date())
        sut.textField.text = note.title
        sut.textView.text = note.content
        
        let saveButton = sut.navigationItem.rightBarButtonItem
        _ = saveButton?.target?.perform(saveButton?.action, with: nil)
        
        XCTAssertTrue(mockRouter.didDismiss)
    }
    
    func test_saveButton_action_withNoInput() {
        
        let saveButton = sut.navigationItem.rightBarButtonItem
        _ = saveButton?.target?.perform(saveButton?.action, with: nil)
        
        XCTAssertEqual(sut.textField.text, "")
        XCTAssertEqual(sut.textView.text, "")
        XCTAssertFalse(mockRouter.didDismiss)
    }
}
