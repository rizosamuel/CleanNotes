//
//  MockFirebaseAuth.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 21/01/25.
//

import FirebaseAuth
@testable import CleanNotes

class MockFirebaseAuth: FirebaseAuthProtocol {
    
    var mockCurrentUser: MockUser?
    var didCreateUser = false
    var didLogin = false
    var didSignOut = false
    var makeCurrentUserNil = false
    
    init(mockCurrentUser: MockUser?) {
        self.mockCurrentUser = mockCurrentUser
    }
    
    var loggedInUser: UserProtocol? {
        return mockCurrentUser
    }

    func signup(withEmail email: String, password: String, completion: ((AuthDataResultProtocol?, Error?) -> Void)?) {
        if let mockUser = mockCurrentUser {
            let mockAuthDataResult = MockAuthDataResult(user: makeCurrentUserNil ? nil : mockUser)
            didCreateUser = true
            completion?(mockAuthDataResult, nil)
        } else {
            didCreateUser = false
            completion?(nil, NSError(domain: "MockAuth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock sign-up error"]))
        }
    }
    
    func login(withEmail email: String, password: String, completion: ((AuthDataResultProtocol?, Error?) -> Void)?) {
        if let mockUser = mockCurrentUser {
            let mockAuthDataResult = MockAuthDataResult(user: makeCurrentUserNil ? nil : mockUser)
            didLogin = true
            completion?(mockAuthDataResult, nil)
        } else {
            didLogin = false
            completion?(nil, NSError(domain: "MockAuth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock login error"]))
        }
    }
    
    func signOut() throws {
        didSignOut = true
        mockCurrentUser = nil
    }
}

class MockAuthDataResult: AuthDataResultProtocol {
    
    let mockUser: UserProtocol?

    init(user: UserProtocol?) {
        self.mockUser = user
    }

    var currentUser: UserProtocol? {
        return mockUser
    }
}

class MockUser: UserProtocol {
    let uid: String
    let email: String?

    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}
