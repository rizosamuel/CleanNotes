//
//  RealmNotesRepositoryImpl.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

import RealmSwift

class RealmNotesRepositoryImpl: NotesRepository {
    
    private let realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
    
    func add(note: Note) {
        do {
            try realm.write {
                let realmNote = RealmNote(note: note)
                realm.add(realmNote, update: .modified)
            }
            print("Note added successfully!")
        } catch {
            print("Error adding note: \(error)")
        }
    }
    
    func fetchNotes(completion: @escaping ([Note]) -> Void) {
        let realmNotes = realm.objects(RealmNote.self)
        let notes = Array(realmNotes.map {
            let id = UUID(uuidString: $0.id) ?? UUID()
            return Note(id: id, title: $0.title, content: $0.content, timeStamp: $0.timeStamp)
        })
        completion(notes)
    }
    
    func deleteAllNotes() {
        do {
            try realm.write {
                let allNotes = realm.objects(RealmNote.self)
                realm.delete(allNotes)
            }
            print("All notes deleted successfully!")
        } catch {
            print("Error deleting all notes: \(error)")
        }
    }
}
