//
//  SettingsViewController.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 22/01/25.
//

import UIKit

class SettingsViewController: UIViewController, FileIdentifier {
    
    enum AppLockMode {
        case enableAppLock, disableAppLock
    }
    
    private let viewModel: SettingsViewModel
    private weak var router: NotesRouter?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .systemBackground
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.register(ToggleTableViewCell.self, forCellReuseIdentifier: ToggleTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    init(viewModel: SettingsViewModel, router: NotesRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.SETTINGS_VIEW_CONTROLLER_TITLE
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        setupTableView()
        viewModel.fetchSettings { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func signOutTapped() {
        let title = "Are you sure?"
        let message = "You'll need to Re-Login to use Spotify"
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let addAction = UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            guard let self else { return }
            viewModel.logOut()
            router?.navigateToRoot()
            print("\n[\(self.fileName)] YOU HAVE SIGNED OUT")
        }
        actionSheet.addAction(addAction)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(actionSheet, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].settings.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = viewModel.sections[indexPath.section].settings[indexPath.row].type
        
        switch type {
        case .logOut, .none:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = viewModel.sections[indexPath.section].settings[indexPath.row].title
            if type == .none {
                config.textProperties.color = .systemGray
            }
            cell.backgroundColor = .secondarySystemBackground
            cell.contentConfiguration = config
            return cell
        case .appLock:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ToggleTableViewCell.identifier, for: indexPath) as? ToggleTableViewCell else { return UITableViewCell() }
            let setting = viewModel.sections[indexPath.section].settings[indexPath.row]
            let isToggleOn = viewModel.isAppLockEnabled
            let viewModel = ToggleTableViewCellViewModel(setting: setting, isToggleOn: isToggleOn)
            cell.configure(with: viewModel)
            cell.backgroundColor = .secondarySystemBackground
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = viewModel.sections[indexPath.section].settings[indexPath.row].type
        
        switch type {
        case .logOut:
            signOutTapped()
        case .appLock:
            break
        case .none:
            break
        }
    }
}

extension SettingsViewController: ToggleTableViewCellDelegate {
    func didToggle(on setting: Setting, _ toggle: UISwitch) {
        switch setting.type {
        case .appLock:
            let appLockMode: AppLockMode = toggle.isOn ? .enableAppLock : .disableAppLock
            performBiometricAuthentication(for: appLockMode, toggle: toggle)
        default:
            break
        }
    }
}

extension SettingsViewController {
    private func performBiometricAuthentication(for appLockMode: AppLockMode, toggle: UISwitch) {
        guard viewModel.isBiometricsAvailable else {
            showSimpleAlert(with: "Oops!!", message: viewModel.biometryErrorReason) { [weak self] in
                toggle.setOn(false, animated: true)
                self?.viewModel.setAppLockEnabled(false)
            }
            return
        }
        
        viewModel.authenticate { [weak self] isSuccess, error in
            switch (appLockMode, isSuccess) {
            case (.enableAppLock, true):
                toggle.setOn(true, animated: true)
                self?.viewModel.setAppLockEnabled(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.showSimpleAlert(with: "Success", message: "You have enabled App lock")
                }
            case (.disableAppLock, true):
                toggle.setOn(false, animated: true)
                self?.viewModel.setAppLockEnabled(false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.showSimpleAlert(with: "Success", message: "You have disabled App lock")
                }
            case (.enableAppLock, false):
                toggle.setOn(false, animated: true)
                self?.viewModel.setAppLockEnabled(false)
            case (.disableAppLock, false):
                toggle.setOn(true, animated: true)
                self?.viewModel.setAppLockEnabled(true)
            }
        }
    }
}
