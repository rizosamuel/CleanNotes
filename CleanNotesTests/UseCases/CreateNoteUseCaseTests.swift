//
//  CreateNoteUseCaseTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import XCTest
@testable import CleanNotes

class CreateNoteUseCaseTests: XCTestCase {
    
    var sut: CreateNoteUseCase!
    var mockRepository: MockNotesRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockNotesRepository()
        sut = CreateNoteUseCaseImpl(repository: mockRepository)
    }
    
    override func tearDown() {
        mockRepository = nil
        sut = nil
        super.tearDown()
    }
    
    func testCreateNote() {
        let title = "Sample Note"
        let content = "This is the content of the sample note."
        
        let note = sut.createNote(title: title, content: content)
        
        XCTAssertNotNil(note)
        XCTAssertNotNil(note.id)
        XCTAssertNotNil(note.timeStamp)
        XCTAssertEqual(note.title, title)
        XCTAssertEqual(note.content, content)
        XCTAssertTrue(mockRepository.addedNote)
        XCTAssertEqual(mockRepository.notes.count, 1)
    }
}
