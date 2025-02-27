//
//  FirebaseAuthHelper.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 21/01/25.
//

import FirebaseAuth

protocol FirebaseAuthProtocol {
    var loggedInUser: UserProtocol? { get }
    func signup(withEmail email: String, password: String, completion: ((AuthDataResultProtocol?, Error?) -> Void)?)
    func login(withEmail email: String, password: String, completion: ((AuthDataResultProtocol?, Error?) -> Void)?)
    func signOut() throws
}

extension Auth: FirebaseAuthProtocol {
    var loggedInUser: UserProtocol? {
        Auth.auth().currentUser
    }
    
    func signup(withEmail email: String, password: String, completion: ((AuthDataResultProtocol?, Error?) -> Void)?) {
        createUser(withEmail: email, password: password, completion: completion)
    }
    
    func login(withEmail email: String, password: String, completion: ((AuthDataResultProtocol?, Error?) -> Void)?) {
        signIn(withEmail: email, password: password, completion: completion)
    }
}

protocol AuthDataResultProtocol {
    var currentUser: UserProtocol? { get }
}

protocol UserProtocol {
    var uid: String { get }
    var email: String? { get }
}

extension AuthDataResult: AuthDataResultProtocol {
    var currentUser: UserProtocol? {
        return self.user
    }
}

extension FirebaseAuth.User: UserProtocol {}
