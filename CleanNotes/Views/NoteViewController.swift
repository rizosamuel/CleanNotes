//
//  NoteViewController.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 16/01/25.
//

import UIKit

class NoteViewController: UIViewController {
    
    private let viewModel: NoteViewModel
    private weak var router: NotesRouter?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    init(viewModel: NoteViewModel, router: NotesRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        setupViews()
        configureViews()
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureViews() {
        titleLabel.text = viewModel.note.title
        contentLabel.text = viewModel.note.content
    }
}
