//
//  FirebaseNotesRepositoryImpl.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

import FirebaseFirestore
import FirebaseAuth

class FirebaseNotesRepositoryImpl: NotesRepository {
    
    private let firestore: Firestore
    private let firebaseAuth: FirebaseAuthProtocol
    
    init(firestore: Firestore = Firestore.firestore(), auth: FirebaseAuthProtocol = Auth.auth()) {
        self.firestore = firestore
        self.firebaseAuth = auth
    }
    
    func add(note: Note) {
        guard let userId = firebaseAuth.loggedInUser?.uid else {
            print("Error: User is not logged in.")
            return
        }
        
        let noteData: [String: Any] = ["id": note.id.uuidString, "title": note.title, "content": note.content, "timeStamp": note.timeStamp]
        
        firestore.collection("users")
            .document(userId)
            .collection("notes") // Store notes in a "notes" subcollection under the user document
            .document(note.id.uuidString)
            .setData(noteData) { error in
                if let error = error {
                    print("Error adding note: \(error.localizedDescription)")
                } else {
                    print("Note added successfully.")
                }
            }
    }
    
    func fetchNotes(completion: @escaping ([Note]) -> Void) {
        guard let userId = firebaseAuth.loggedInUser?.uid else {
            print("Error: User is not logged in.")
            completion([])
            return
        }
        
        firestore.collection("users")
            .document(userId)
            .collection("notes")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching notes: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let notes = documents.compactMap { document -> Note? in
                    let data = document.data()
                    guard let title = data["title"] as? String,
                          let content = data["content"] as? String,
                          let timestamp = data["timeStamp"] as? Timestamp else { return nil }
                    
                    let id = UUID(uuidString: document.documentID) ?? UUID()
                    return Note(id: id, title: title, content: content, timeStamp: timestamp.dateValue())
                }
                
                completion(notes)
            }
    }
    
    func deleteAllNotes(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = firebaseAuth.loggedInUser?.uid else {
            print("Error: User is not logged in.")
            completion(.failure(NSError(domain: "NoUser", code: 0, userInfo: nil)))
            return
        }
        
        firestore.collection("users")
            .document(userId)
            .collection("notes")
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success(()))
                    return
                }
                
                let batch = self?.firestore.batch()
                documents.forEach { batch?.deleteDocument($0.reference) }
                batch?.commit { batchError in
                    if let batchError = batchError {
                        completion(.failure(batchError))
                    } else {
                        completion(.success(()))
                    }
                }
            }
    }
    
    // Persist Notes Across App Installs
    func syncNotesToFirestore(notes: [Note], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = firebaseAuth.loggedInUser?.uid else {
            print("Error: User is not logged in.")
            completion(.failure(NSError(domain: "NoUser", code: 0, userInfo: nil)))
            return
        }
        
        let batch = firestore.batch()
        let notesCollection = firestore.collection("users").document(userId).collection("notes")
        
        notes.forEach { note in
            let noteData: [String: Any] = ["id": note.id.uuidString, "title": note.title, "content": note.content, "timeStamp": note.timeStamp]
            let documentRef = notesCollection.document(note.id.uuidString)
            batch.setData(noteData, forDocument: documentRef)
        }
        
        batch.commit { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
