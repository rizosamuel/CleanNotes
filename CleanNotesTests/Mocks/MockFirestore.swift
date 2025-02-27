//
//  MockFirestore.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 21/01/25.
//

//import FirebaseFirestore
//@testable import CleanNotes

//class MockFirestore: FirestoreProtocol {
//    var collections: [String: MockCollectionReference] = [:]
//    
//    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
//        if let collection = collections[collectionPath] {
//            return collection
//        } else {
//            let collection = MockCollectionReference()
//            collections[collectionPath] = collection
//            return collection
//        }
//    }
//    
//    func batch() -> WriteBatchProtocol {
//        return MockWriteBatch()
//    }
//}
//
//class MockWriteBatch: WriteBatchProtocol {
//    private var operations: [((Error?) -> Void)?] = []
//    
//    func setData(_ document: DocumentReferenceProtocol, data: [String: Any]) {
//        operations.append(nil)
//    }
//    
//    func deleteDocument(_ document: DocumentReferenceProtocol) {
//        operations.append(nil)
//    }
//    
//    func commit(completion: ((Error?) -> Void)?) {
//        completion?(nil) // Simulate a successful batch commit
//    }
//}
//
//class MockCollectionReference: CollectionReferenceProtocol {
//    var documents: [String: MockDocumentReference] = [:]
//    
//    func document(_ documentPath: String) -> DocumentReferenceProtocol {
//        if let document = documents[documentPath] {
//            return document
//        } else {
//            let document = MockDocumentReference(documentID: documentPath)
//            documents[documentPath] = document
//            return document
//        }
//    }
//    
//    func getDocuments(completion: @escaping (QuerySnapshotProtocol?, Error?) -> Void) {
//        let snapshot = MockQuerySnapshot(
//            documents: documents.values.map { MockDocumentSnapshot(reference: $0, data: $0.data) }
//        )
//        completion(snapshot, nil) // Simulate fetching documents
//    }
//}
//
//class MockDocumentReference: DocumentReferenceProtocol {
//    let documentID: String
//    var data: [String: Any]?
//    private var collections: [String: MockCollectionReference] = [:]
//    
//    init(documentID: String) {
//        self.documentID = documentID
//    }
//    
//    func setData(_ data: [String: Any], completion: ((Error?) -> Void)?) {
//        self.data = data
//        completion?(nil) // Simulate a successful setData operation
//    }
//    
//    func getDocument(completion: @escaping (DocumentSnapshotProtocol?, Error?) -> Void) {
//        let snapshot = MockDocumentSnapshot(reference: self, data: data)
//        completion(snapshot, nil) // Simulate fetching a document
//    }
//    
//    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
//        if let collection = collections[collectionPath] {
//            return collection
//        } else {
//            let collection = MockCollectionReference()
//            collections[collectionPath] = collection
//            return collection
//        }
//    }
//}
//
//class MockDocumentSnapshot: DocumentSnapshotProtocol {
//    var documentID: String
//    var reference: DocumentReferenceProtocol
//    private var snapshotData: [String: Any]?
//    
//    init(reference: DocumentReferenceProtocol, data: [String: Any]?) {
//        self.reference = reference
//        self.documentID = (reference as? MockDocumentReference)?.documentID ?? ""
//        self.snapshotData = data
//    }
//    
//    func data() -> [String: Any]? {
//        return snapshotData
//    }
//}
//
//class MockQuerySnapshot: QuerySnapshotProtocol {
//    var documents: [DocumentSnapshotProtocol]
//    
//    init(documents: [DocumentSnapshotProtocol]) {
//        self.documents = documents
//    }
//}
