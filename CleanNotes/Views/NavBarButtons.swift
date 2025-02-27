//
//  NavBarButtons.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 25/02/25.
//

import UIKit

protocol NavBarButtonsDelegate: AnyObject {
    func didTapAdd()
    func didTapSettings()
}

class NavBarButtons: UIView {
    
    weak var delegate: NavBarButtonsDelegate?

    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .label
        return button
    }()

    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .label
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [addButton, settingsButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
    }
    
    @objc private func didTapAdd() {
        delegate?.didTapAdd()
    }
    
    @objc private func didTapSettings() {
        delegate?.didTapSettings()
    }
}
