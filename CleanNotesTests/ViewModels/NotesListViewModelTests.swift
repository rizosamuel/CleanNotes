//
//  NotesListViewModelTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 21/01/25.
//

import XCTest
@testable import CleanNotes

class NotesListViewModelTests: XCTestCase {
    
    var sut: NotesListViewModel!
    var mockAuthRepo: MockAuthRepository!
    var mockNotesRepo: MockNotesRepository!
    
    override func setUp() {
        super.setUp()
        mockAuthRepo = MockAuthRepository()
        mockNotesRepo = MockNotesRepository()
        sut = NotesListViewModel(authRepo: mockAuthRepo, notesRepo: mockNotesRepo)
    }
    
    override func tearDown() {
        sut = nil
        mockNotesRepo = nil
        mockAuthRepo = nil
        super.tearDown()
    }
    
    func test_fetchNotes() {
        let expectation = self.expectation(description: "Fetch notes successful")
        sut.fetchNotes { [weak self] in
            XCTAssertTrue(self!.mockNotesRepo.fetchedNotes)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
