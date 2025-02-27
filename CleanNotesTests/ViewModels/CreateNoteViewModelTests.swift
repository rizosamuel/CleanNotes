//
//  CreateNoteViewModelTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import XCTest
@testable import CleanNotes

class CreateNoteViewModelTests: XCTestCase {
    
    var sut: CreateNoteViewModel!
    var mockUseCase: MockCreateNoteUseCase!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockCreateNoteUseCase()
        sut = CreateNoteViewModel(useCase: mockUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func testCreateNote() {
        let title = "Sample Note"
        let content = "This is the content of the sample note."
        let newNote = sut.createNote(with: title, content: content)
        
        XCTAssertTrue(mockUseCase.createdNote)
        XCTAssertNotNil(newNote)
        XCTAssertEqual(newNote.title, title)
        XCTAssertEqual(newNote.content, content)
    }
}
