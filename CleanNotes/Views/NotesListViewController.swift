//
//  NotesListViewController.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 16/01/25.
//

import UIKit

class NotesListViewController: UIViewController, FileIdentifier {
    
    private let viewModel: NotesListViewModel
    private weak var router: NotesRouter?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    init(viewModel: NotesListViewModel, router: NotesRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.NOTES_LIST_VIEW_CONTROLLER_TITLE
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        setupNavButtons()
        setupTableView()
        fetchNotes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard !viewModel.authRepository.isLoggedIn else { return }
        print("\n[\(fileName)] USER NOT SIGNED IN")
        let authRepository = viewModel.authRepository
        let authUseCase = AuthUseCaseImpl(authRepository: authRepository)
        router?.presentAuthVC(authRepo: authRepository, useCase: authUseCase, delegate: self)
    }
    
    private func setupNavButtons() {
        let customButtons = NavBarButtons()
        customButtons.delegate = self
        
        let barButtonItem = UIBarButtonItem(customView: customButtons)
        navigationItem.rightBarButtonItem = barButtonItem
        
        // let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(didTapAdd))
        // let gearButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(didTapSettings))
        // navigationItem.rightBarButtonItems = [gearButton, addButton]
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchNotes() {
        viewModel.fetchNotes() { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension NotesListViewController: NavBarButtonsDelegate {
    func didTapAdd() {
        let useCase = CreateNoteUseCaseImpl(repository: viewModel.notesRepository)
        router?.navigateToCreateNoteVC(useCase: useCase, delegate: self)
    }
    
    func didTapSettings() {
        let authRepo = viewModel.authRepository
        let settingsUseCase = SettingsUseCaseImpl(repository: InMemorySettingsRepositoryImpl(authRepository: authRepo))
        router?.navigateToSettingsVC(useCase: settingsUseCase)
    }
}

extension NotesListViewController: CreateNoteViewControllerDelegate {
    func didCreateNote(with note: Note) {
        fetchNotes()
    }
}

extension NotesListViewController: AuthViewControllerDelegate {
    func didLogin() {
        fetchNotes()
    }
}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = viewModel.notes[indexPath.row].title
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = viewModel.notes[indexPath.row]
        router?.navigateToNoteVC(with: note)
    }
}
