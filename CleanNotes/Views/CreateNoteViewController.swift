//
//  CreateNoteViewController.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 16/01/25.
//

import UIKit

protocol CreateNoteViewControllerDelegate: AnyObject {
    func didCreateNote(with note: Note)
}

class CreateNoteViewController: UIViewController {
    
    private let viewModel: CreateNoteViewModel
    private weak var router: NotesRouter?
    weak var delegate: CreateNoteViewControllerDelegate?
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "enter title..."
        return textField
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    init(viewModel: CreateNoteViewModel, router: NotesRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.CREATE_NOTE_VIEW_CONTROLLER_TITLE
        view.backgroundColor = .systemBackground
        
        setupCloseButton()
        setupSaveButton()
        setupTextField()
        setupTextView()
    }
    
    private func setupCloseButton() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.leftBarButtonItem = closeButton
    }
    
    private func setupSaveButton() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupTextField() {
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTextView() {
        view.addSubview(textView)
        textView.backgroundColor = .secondarySystemBackground
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func didTapClose() {
        router?.dismiss(self)
    }
    
    @objc private func didTapSave() {
        guard let title = textField.text, !title.isEmpty, let content = textView.text, !content.isEmpty else { return }
        let note = viewModel.createNote(with: title, content: content)
        delegate?.didCreateNote(with: note)
        router?.dismiss(self)
    }
}
