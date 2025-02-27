//
//  AuthViewController.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 20/01/25.
//

import UIKit
import Combine

protocol AuthViewControllerDelegate: AnyObject {
    func didLogin()
}

class AuthViewController: UIViewController {
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textContentType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: AuthViewControllerDelegate?
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        title = Constants.AUTH_VIEW_CONTROLLER_TITLE
        view.backgroundColor = .systemBackground
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(errorMessageLabel)
        view.addSubview(activityIndicator)
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        view.addSubview(signupButton)
        signupButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            errorMessageLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            errorMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loginButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // ViewModel Binding
    private func bindViewModel() {
        viewModel.$isLoading.sink { [weak self] isLoading in
            if isLoading {
                self?.startLoading()
            } else {
                self?.stopLoading()
            }
        }.store(in: &cancellables)
        
        viewModel.$user.sink { [weak self] user in
            guard user != nil else { return }
            self?.delegate?.didLogin()
            self?.dismiss(animated: true)
        }.store(in: &cancellables)
        
        viewModel.$errorMessage.sink { [weak self] errorMessage in
            self?.showErrorMessage(with: errorMessage ?? "")
        }.store(in: &cancellables)
    }
    
    @objc private func didTapLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        viewModel.login(email: email, password: password)
    }
    
    @objc private func didTapSignUp() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        viewModel.signup(email: email, password: password)
    }
    
    private func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    private func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func showErrorMessage(with message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessageLabel.text = message
        }
    }
}
