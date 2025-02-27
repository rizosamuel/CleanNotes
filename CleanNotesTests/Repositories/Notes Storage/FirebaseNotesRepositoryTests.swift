//
//  FirebaseNotesRepositoryTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 21/01/25.
//

import XCTest
@testable import CleanNotes

class FirebaseNotesRepositoryTests: XCTestCase {
    
    var sut: FirebaseNotesRepositoryImpl!
    var mockUser: MockUser!
    var mockFirebaseAuth: MockFirebaseAuth!
    let dispatchSemaphore = DispatchSemaphore(value: 1)
    
    override func setUp() {
        super.setUp()
        mockUser = MockUser(uid: "mockId", email: "mockEmail@email.com")
        mockFirebaseAuth = MockFirebaseAuth(mockCurrentUser: mockUser)
        sut = FirebaseNotesRepositoryImpl(auth: mockFirebaseAuth)
    }
    
    override func tearDown() {
        mockUser = nil
        mockFirebaseAuth = nil
        sut = nil
        super.tearDown()
    }
    
    func test_addNote_loggedInUser_isNil() {
        dispatchSemaphore.wait()
        sut.deleteAllNotes { [weak self] _ in
            self?.dispatchSemaphore.signal()
        }
        mockFirebaseAuth.mockCurrentUser = nil
        let note = Note(id: UUID(), title: "Sample Note", content: "This is a test note", timeStamp: Date())
        sut.add(note: note)
        XCTAssertNil(mockFirebaseAuth.loggedInUser)
        
        let expectation = self.expectation(description: "Fetch notes should fail")
        sut.fetchNotes { fetchedNotes in
            XCTAssertTrue(fetchedNotes.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_addNote() {
        dispatchSemaphore.wait()
        sut.deleteAllNotes { [weak self] _ in
            self?.dispatchSemaphore.signal()
        }
        let note = Note(id: UUID(), title: "Sample Note", content: "This is a test note", timeStamp: Date())
        sut.add(note: note)
        XCTAssertEqual(mockUser.uid, mockFirebaseAuth.loggedInUser?.uid)
        
        let expectation = self.expectation(description: "Fetch notes after adding a note")
        sut.fetchNotes { fetchedNotes in
            XCTAssertEqual(fetchedNotes.count, 1, "The repository should contain exactly one note.")
            XCTAssertEqual(fetchedNotes.first?.title, note.title, "The title of the fetched note should match the added note.")
            XCTAssertEqual(fetchedNotes.first?.content, note.content, "The content of the fetched note should match the added note.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_fetchNotes_initiallyEmpty() {
        dispatchSemaphore.wait()
        sut.deleteAllNotes { [weak self] _ in
            self?.dispatchSemaphore.signal()
        }
        XCTAssertEqual(mockUser.uid, mockFirebaseAuth.loggedInUser?.uid)
        let expectation = self.expectation(description: "Fetch notes after adding a note")
        
        sut.fetchNotes { fetchedNotes in
            XCTAssertTrue(fetchedNotes.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func test_fetchNotes_afterAddingNotes() {
        dispatchSemaphore.wait()
        sut.deleteAllNotes { [weak self] _ in
            self?.dispatchSemaphore.signal()
        }
        let note1 = Note(id: UUID(), title: "First Note", content: "Content of the first note", timeStamp: Date())
        let note2 = Note(id: UUID(), title: "Second Note", content: "Content of the second note", timeStamp: Date())
        sut.add(note: note1)
        sut.add(note: note2)
        
        XCTAssertEqual(mockUser.uid, mockFirebaseAuth.loggedInUser?.uid)
        let expectation = self.expectation(description: "Fetch notes after adding a note")
        
        sut.fetchNotes { fetchedNotes in
            let notes = fetchedNotes.sorted { $0.title < $1.title }
            XCTAssertEqual(notes.count, 2, "The repository should contain exactly two notes.")
            XCTAssertEqual(notes[0].title, note1.title, "The first note's title should match.")
            XCTAssertEqual(notes[1].title, note2.title, "The second note's title should match.")
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func test_deleteAllNotes() {
        let note1 = Note(id: UUID(), title: "First Note", content: "Content of the first note", timeStamp: Date())
        let note2 = Note(id: UUID(), title: "Second Note", content: "Content of the second note", timeStamp: Date())
        sut.add(note: note1)
        sut.add(note: note2)
        
        dispatchSemaphore.wait()
        sut.deleteAllNotes { [weak self] _ in
            self?.dispatchSemaphore.signal()
        }
        
        let expectation = self.expectation(description: "Fetch notes should be empty")
        
        sut.fetchNotes { fetchedNotes in
            print(fetchedNotes)
            XCTAssertTrue(fetchedNotes.count == 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
}
