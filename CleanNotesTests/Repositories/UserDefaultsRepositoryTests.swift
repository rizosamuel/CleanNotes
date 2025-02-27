//
//  UserDefaultsRepositoryTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/02/25.
//

import XCTest
@testable import CleanNotes

class UserDefaultsRepositoryTests: XCTestCase {
    
    var userDefaults: UserDefaults!
    var sut: UserDefaultsRepositoryImpl!
    
    override func setUp() {
        super.setUp()
        // Use a separate suite to avoid affecting real user defaults
        userDefaults = UserDefaults(suiteName: "TestUserDefaults")
        sut = UserDefaultsRepositoryImpl(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "TestUserDefaults")
        userDefaults = nil
        sut = nil
        super.tearDown()
    }
    
    func test_saveAndRetrieveCodableObject() {
        struct MockUser: Codable, Equatable {
            let id: Int
            let name: String
        }
        
        let user = MockUser(id: 1, name: "John Doe")
        let key = "mockUser"
        
        sut.save(user, forKey: key)
        
        let retrievedUser: MockUser? = sut.get(forKey: key, type: MockUser.self)
        
        XCTAssertEqual(retrievedUser, user, "Retrieved user should match the saved user")
    }
    
    func test_saveAndRetrieveString() {
        let key = "mockString"
        let value = "Hello, World!"
        
        sut.save(value, forKey: key)
        
        let retrievedValue: String? = sut.get(forKey: key, type: String.self)
        
        XCTAssertEqual(retrievedValue, value, "Retrieved string should match the saved string")
    }
    
    func test_saveAndRetrieveInt() {
        let key = "mockInt"
        let value = 42
        
        sut.save(value, forKey: key)
        
        let retrievedValue: Int? = sut.get(forKey: key, type: Int.self)
        
        XCTAssertEqual(retrievedValue, value, "Retrieved Int should match the saved Int")
    }
    
    func test_retrieve_withInvalidType() {
        let key = "mockInt"
        let value = "42A"
        
        sut.save(value, forKey: key)
        
        let retrievedValue: Int? = sut.get(forKey: key, type: Int.self)
        
        XCTAssertNil(retrievedValue)
    }
    
    func test_deleteValue() {
        let key = "mockDeleteKey"
        let value = "To be deleted"
        
        sut.save(value, forKey: key)
        sut.delete(forKey: key)
        
        let retrievedValue: String? = sut.get(forKey: key, type: String.self)
        
        XCTAssertNil(retrievedValue, "Value should be nil after deletion")
    }
    
    // Test clearing all values
    func test_clearAll() {
        sut.save("test1", forKey: "key1")
        sut.save(123, forKey: "key2")
        
        sut.clearAll(userDefaultsName: "TestUserDefaults")
        
        let retrievedValue1: String? = sut.get(forKey: "key1", type: String.self)
        let retrievedValue2: Int? = sut.get(forKey: "key2", type: Int.self)
        
        XCTAssertNil(retrievedValue1, "All values should be cleared")
        XCTAssertNil(retrievedValue2, "All values should be cleared")
    }
}
