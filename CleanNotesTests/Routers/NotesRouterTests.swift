//
//  NotesRouterTests.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 17/01/25.
//

import XCTest
@testable import CleanNotes

class NotesRouterTests: XCTestCase {
    var sut: NotesRouterImpl!
    var mockNavController: MockNavigationController!
    
    override func setUp() {
        super.setUp()
        mockNavController = MockNavigationController()
        sut = NotesRouterImpl(navigationController: mockNavController)
    }
    
    override func tearDown() {
        mockNavController = nil
        sut = nil
        super.tearDown()
    }
    
    func testCreateNotesListViewController() {
        let mockAuthRepo = MockAuthRepository()
        let mockNotesRepo = MockNotesRepository()
        let navController = sut.createNotesListVC(authRepo: mockAuthRepo, notesRepo: mockNotesRepo)
        XCTAssertNotNil(navController)
        XCTAssertEqual(navController, mockNavController)
        XCTAssertTrue(mockNavController.viewControllers.first is NotesListViewController)
    }
    
    func testPresentAuthVC() {
        let mockAuthRepo = MockAuthRepository()
        let mockUseCase = MockAuthUseCase()
        let mockDelegate = MockAuthViewControllerDelegate()
        sut.presentAuthVC(authRepo: mockAuthRepo, useCase: mockUseCase, delegate: mockDelegate)
        XCTAssertTrue(mockNavController.presentedVC is UINavigationController)
        let navVC = mockNavController.presentedVC as? UINavigationController
        XCTAssertTrue(navVC?.viewControllers.first is AuthViewController)
    }
    
    func testNavigateToCreateNote() {
        let mockUseCase = MockCreateNoteUseCase()
        let mockDelegate = MockCreateNoteViewControllerDelegate()
        sut.navigateToCreateNoteVC(useCase: mockUseCase, delegate: mockDelegate)
        XCTAssertTrue(mockNavController.presentedVC is UINavigationController)
        let navVC = mockNavController.presentedVC as? UINavigationController
        XCTAssertTrue(navVC?.viewControllers.first is CreateNoteViewController)
    }
    
    func testNavigateToNote() {
        let mockNote = Note(id: UUID(), title: "mock title", content: "mock content", timeStamp: Date())
        sut.navigateToNoteVC(with: mockNote)
        XCTAssertTrue(mockNavController.pushedVC is NoteViewController)
    }
    
    func testNavigateToSettings() {
        let mockUseCase = MockSettingsUseCase()
        sut.navigateToSettingsVC(useCase: mockUseCase)
        XCTAssertTrue(mockNavController.pushedVC is SettingsViewController)
    }
    
    func testDismiss() {
        let mockViewController = MockViewController()
        sut.dismiss(mockViewController)
        XCTAssertTrue(mockViewController.dismissCalled)
    }
}
