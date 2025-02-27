//
//  ToggleTableViewCell.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 27/01/25.
//

import UIKit

protocol ToggleTableViewCellDelegate: AnyObject {
    func didToggle(on setting: Setting, _ toggle: UISwitch)
}

class ToggleTableViewCell: UITableViewCell {
    static let identifier = String(describing: ToggleTableViewCell.self)
    
    weak var delegate: ToggleTableViewCellDelegate?
    private var currentSetting: Setting?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggle)
        constrainViews()
        
        toggle.addTarget(self, action: #selector(didToggle), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        toggle.isOn = false
    }
    
    private func constrainViews() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            toggle.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15),
            toggle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            toggle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    func configure(with viewModel: ToggleTableViewCellViewModel) {
        titleLabel.text = viewModel.setting.title
        toggle.isOn = viewModel.isToggleOn
        currentSetting = viewModel.setting
    }
    
    @objc private func didToggle(_ toggle: UISwitch) {
        guard let currentSetting else { return }
        delegate?.didToggle(on: currentSetting, toggle)
    }
}
