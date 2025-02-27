//
//  CloudKitNotesRepositoryImpl.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

//import Foundation
//import CloudKit
//
//fileprivate typealias FetchResult = Result<(matchResults: [(CKRecord.ID, Result<CKRecord, Error>)], queryCursor: CKQueryOperation.Cursor?), Error>
//
//class CloudKitNotesRepositoryImpl: NotesRepository {
//    private let database: CKDatabase
//    private let recordType = "Note"
//    
//    init(containerId: String? = nil) {
//        // initialize the cloudkit public DB
//        let container = containerId != nil ? CKContainer(identifier: containerId!) : CKContainer.default()
//        self.database = container.publicCloudDatabase
//    }
//    
//    func add(note: Note) {
//        // Create a CKRecord for the note
//        let record = CKRecord(recordType: recordType)
//        record["id"] = note.id.uuidString as CKRecordValue
//        record["title"] = note.title as CKRecordValue
//        record["content"] = note.content as CKRecordValue
//        record["timeStamp"] = note.timeStamp as CKRecordValue
//        
//        // Save the record to CloudKit
//        database.save(record) { _, error in
//            if let error = error {
//                print("Error adding note: \(error)")
//            } else {
//                print("Note added successfully!")
//            }
//        }
//    }
//    
//    func fetchNotes() -> [Note] {
//        var notes: [Note] = []
//        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
//        
//        // Fetch all notes from CloudKit
//        database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { (result: FetchResult) in
//            
//            switch result {
//            case .success((let matchResults, _)):
//                for (recordId, matchResult) in matchResults {
//                    switch matchResult {
//                    case .success(let record):
//                        if let note = self.getNote(from: record) {
//                            notes.append(note)
//                        }
//                    case .failure(let error):
//                        print("Error fetching record with ID \(recordId): \(error.localizedDescription)")
//                    }
//                }
//            case .failure(let error):
//                print("Error fetching notes: \(error.localizedDescription)")
//            }
//        }
//        
//        return notes
//    }
//    
//    private func getNote(from record: CKRecord) -> Note? {
//        guard let id = UUID(uuidString: record.recordID.recordName),
//              let title = record["title"] as? String,
//              let content = record["content"] as? String,
//              let timeStamp = record["timeStamp"] as? Date else { return nil }
//        
//        return Note(id: id, title: title, content: content, timeStamp: timeStamp)
//    }
//    
//    func deleteAllNotes() {
//        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
//        
//        database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { (result: FetchResult) in
//            
//            switch result {
//            case .success(let (matchResults, _)):
//                // Extracting record IDs from the match results
//                let recordIDs = matchResults.compactMap { (recordID, result) -> CKRecord.ID? in
//                    switch result {
//                    case .success(let record):
//                        return record.recordID
//                    case .failure:
//                        return nil
//                    }
//                }
//                
//                // Delete all fetched notes
//                let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDs)
//                operation.modifyRecordsResultBlock = { result in
//                    switch result {
//                    case .success:
//                        print("Deleted \(recordIDs.count) notes successfully!")
//                    case .failure(let error):
//                        print("Error deleting notes: \(error)")
//                    }
//                }
//                
//                self.database.add(operation)
//                
//            case .failure(let error):
//                print("Error fetching notes for deletion: \(error)")
//            }
//        }
//    }
//}
