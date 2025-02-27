//
//  FileManagerNotesRepositoryTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import XCTest
@testable import CleanNotes

class FileManagerNotesRepositoryTests: XCTestCase {
    
    var sut: FileManagerNotesRepositoryImpl!
    
    override func setUp() {
        super.setUp()
        sut = FileManagerNotesRepositoryImpl(fileName: "mockNotes.json")
        clearTestFile()
    }
    
    override func tearDown() {
        clearTestFile()
        sut = nil
        super.tearDown()
    }
    
    func test_addNote_toValidPath() {
        let note = Note(id: UUID(), title: "Sample Note", content: "This is a test note", timeStamp: Date())
        sut.add(note: note)
        
        let expectation = self.expectation(description: "Fetch notes after adding a note")
        sut.fetchNotes { fetchedNotes in
            XCTAssertEqual(fetchedNotes.count, 1, "The repository should contain exactly one note.")
            XCTAssertEqual(fetchedNotes.first?.title, note.title, "The title of the fetched note should match the added note.")
            XCTAssertEqual(fetchedNotes.first?.content, note.content, "The content of the fetched note should match the added note.")
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func test_addNote_toInvalidPath() {
        sut = FileManagerNotesRepositoryImpl(fileName: "")
        let note = Note(id: UUID(), title: "Test Note", content: "Test Content", timeStamp: Date())
        sut.add(note: note)
        
        let expectation = self.expectation(description: "Fetch notes after adding a note")
        sut.fetchNotes { fetchedNotes in
            XCTAssertTrue(fetchedNotes.isEmpty, "The repository should handle a non-existent file URL gracefully.")
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func test_fetchNotes_initiallyEmpty() {
        let expectation = self.expectation(description: "Fetch notes after adding a note")
        sut.fetchNotes { fetchedNotes in
            XCTAssertTrue(fetchedNotes.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func test_fetchNotes_fromInvalidPath() {
        sut = FileManagerNotesRepositoryImpl(fileName: "")
        
        let expectation = self.expectation(description: "Fetch notes after adding a note")
        sut.fetchNotes { fetchedNotes in
            XCTAssertTrue(fetchedNotes.isEmpty, "The repository should handle a non-existent file URL gracefully.")
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func test_fetchNotes_fromValidPath() {
        let note1 = Note(id: UUID(), title: "First Note", content: "Content of the first note", timeStamp: Date())
        let note2 = Note(id: UUID(), title: "Second Note", content: "Content of the second note", timeStamp: Date())
        sut.add(note: note1)
        sut.add(note: note2)
        
        let expectation = self.expectation(description: "Fetch notes after adding a note")
        sut.fetchNotes { fetchedNotes in
            XCTAssertEqual(fetchedNotes.count, 2, "The repository should contain exactly two notes.")
            XCTAssertEqual(fetchedNotes[0].title, note1.title, "The first note's title should match.")
            XCTAssertEqual(fetchedNotes[1].title, note2.title, "The second note's title should match.")
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    private func clearTestFile() {
        sut.removeAllNotesFile()
    }
}
