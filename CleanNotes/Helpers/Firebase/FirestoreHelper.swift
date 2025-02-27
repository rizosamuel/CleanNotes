//
//  FirestoreHelper.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 21/01/25.
//

//import FirebaseFirestore
//
//protocol FirestoreProtocol {
//    func collection(_ collectionPath: String) -> CollectionReferenceProtocol
//    func batch() -> WriteBatchProtocol
//}
//
//protocol WriteBatchProtocol {
//    func setData(_ document: DocumentReferenceProtocol, data: [String: Any])
//    func deleteDocument(_ document: DocumentReferenceProtocol)
//    func commit(completion: ((Error?) -> Void)?)
//}
//
//protocol CollectionReferenceProtocol {
//    func document(_ documentPath: String) -> DocumentReferenceProtocol
//    func getDocuments(completion: @escaping (QuerySnapshotProtocol?, Error?) -> Void)
//}
//
//protocol DocumentReferenceProtocol {
//    func setData(_ data: [String: Any], completion: ((Error?) -> Void)?)
//    func getDocument(completion: @escaping (DocumentSnapshotProtocol?, Error?) -> Void)
//    func collection(_ collectionPath: String) -> CollectionReferenceProtocol
//}
//
//protocol DocumentSnapshotProtocol {
//    var documentID: String { get }
//    func data() -> [String: Any]?
//    var reference: DocumentReferenceProtocol { get }
//}
//
//protocol QuerySnapshotProtocol {
//    var documents: [DocumentSnapshotProtocol] { get }
//}
//
//extension Firestore: FirestoreProtocol {
//    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
//        return self.collection(collectionPath) as CollectionReference
//    }
//    
//    func batch() -> WriteBatchProtocol {
//        return self.batch() as WriteBatch
//    }
//}
//
//extension WriteBatch: WriteBatchProtocol {
//    func setData(_ document: DocumentReferenceProtocol, data: [String: Any]) {
//        guard let documentRef = document as? DocumentReference else { return }
//        self.setData(data, forDocument: documentRef)
//    }
//    
//    func deleteDocument(_ document: DocumentReferenceProtocol) {
//        guard let documentRef = document as? DocumentReference else { return }
//        self.deleteDocument(documentRef)
//    }
//    
//    func commit(completion: ((Error?) -> Void)?) {
//        self.commit(completion: completion)
//    }
//}
//
//extension CollectionReference: CollectionReferenceProtocol {
//    func document(_ documentPath: String) -> DocumentReferenceProtocol {
//        return self.document(documentPath) as DocumentReference
//    }
//    
//    func getDocuments(completion: @escaping (QuerySnapshotProtocol?, Error?) -> Void) {
//        self.getDocuments { snapshot, error in
//            if let snapshot = snapshot {
//                completion(snapshot as QuerySnapshot, error)
//            } else {
//                completion(nil, error)
//            }
//        }
//    }
//}
//
//extension DocumentReference: DocumentReferenceProtocol {
//    func setData(_ data: [String: Any], completion: ((Error?) -> Void)?) {
//        self.setData(data, completion: completion)
//    }
//    
//    func getDocument(completion: @escaping (DocumentSnapshotProtocol?, Error?) -> Void) {
//        self.getDocument { snapshot, error in
//            if let snapshot = snapshot {
//                completion(snapshot as DocumentSnapshot, error)
//            } else {
//                completion(nil, error)
//            }
//        }
//    }
//    
//    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
//        return self.collection(collectionPath) as CollectionReference
//    }
//}
//
//extension DocumentSnapshot: DocumentSnapshotProtocol {
//    var reference: DocumentReferenceProtocol {
//        return self.reference
//    }
//    
//    func data() -> [String: Any]? {
//        return self.data()
//    }
//}
//
//extension QuerySnapshot: QuerySnapshotProtocol {
//    var documents: [DocumentSnapshotProtocol] {
//        return self.documents
//    }
//}
