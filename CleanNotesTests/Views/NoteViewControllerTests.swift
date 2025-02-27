//
//  NoteViewControllerTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import XCTest
@testable import CleanNotes

class NoteViewControllerTests: XCTestCase {
    
    var sut: NoteViewController!
    var mockNote: Note!
    var mockViewModel: NoteViewModel!
    var mockRouter: MockNotesRouter!
    
    override func setUp() {
        super.setUp()
        mockNote = Note(id: UUID(), title: "Sample Note", content: "This is a test note", timeStamp: Date())
        mockViewModel = NoteViewModel(note: mockNote)
        mockRouter = MockNotesRouter()
        sut = NoteViewController(viewModel: mockViewModel, router: mockRouter)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        mockRouter = nil
        mockNote = nil
        mockViewModel = nil
        sut = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_setsUpUI() {
        XCTAssertEqual(sut.view.backgroundColor, .systemBackground)
        XCTAssertTrue(sut.view.subviews.contains(sut.titleLabel))
        XCTAssertTrue(sut.view.subviews.contains(sut.contentLabel))
        XCTAssertEqual(sut.titleLabel.text, mockNote.title)
        XCTAssertEqual(sut.contentLabel.text, mockNote.content)
    }
}
