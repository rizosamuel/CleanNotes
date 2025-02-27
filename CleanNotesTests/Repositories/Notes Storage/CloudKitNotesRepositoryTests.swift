//
//  CloudKitNotesRepositoryTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

//import XCTest
//@testable import CleanNotes
//
//class CloudKitNotesRepositoryTests: XCTestCase {
//    
//    var sut: CloudKitNotesRepositoryImpl!
//    
//    override func setUp() {
//        super.setUp()
//        sut = CloudKitNotesRepositoryImpl()
//        sut.deleteAllNotes()
//    }
//    
//    override func tearDown() {
//        sut = nil
//        super.tearDown()
//    }
//    
//    func test_addNote() {
//        let note = Note(id: UUID(), title: "Sample Note", content: "This is a test note", timeStamp: Date())
//        sut.add(note: note)
//        let fetchedNotes = sut.fetchNotes()
//        
//        XCTAssertEqual(fetchedNotes.count, 1, "The repository should contain exactly one note.")
//        XCTAssertEqual(fetchedNotes.first?.title, note.title, "The title of the fetched note should match the added note.")
//        XCTAssertEqual(fetchedNotes.first?.content, note.content, "The content of the fetched note should match the added note.")
//    }
//    
//    func test_fetchNotes_initiallyEmpty() {
//        let notes = sut.fetchNotes()
//        XCTAssertTrue(notes.isEmpty)
//    }
//    
//    func test_fetchNotes_afterAddingNotes() {
//        let note1 = Note(id: UUID(), title: "First Note", content: "Content of the first note", timeStamp: Date())
//        let note2 = Note(id: UUID(), title: "Second Note", content: "Content of the second note", timeStamp: Date())
//        sut.add(note: note1)
//        sut.add(note: note2)
//        let fetchedNotes = sut.fetchNotes()
//        
//        XCTAssertEqual(fetchedNotes.count, 2, "The repository should contain exactly two notes.")
//        XCTAssertEqual(fetchedNotes[0].title, note1.title, "The first note's title should match.")
//        XCTAssertEqual(fetchedNotes[1].title, note2.title, "The second note's title should match.")
//    }
//}
