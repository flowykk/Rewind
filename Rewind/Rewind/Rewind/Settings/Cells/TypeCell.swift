//
//  TypeCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 30.03.2024.
//

import UIKit

final class TypeCell: UITableViewCell {
    private let nameLabel: UILabel = UILabel()
    private let toggleSwitch: UISwitch = UISwitch()
    
    private var type: TypesTableView.TypeRow?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset = UIEdgeInsets(top: 0, left: nameLabel.frame.origin.x, bottom: 0, right: 0)
    }
    
    @objc
    private func toggled() {
        if let type = type {
            DataManager.shared.setNewTypeValue(forType: type, newValue: toggleSwitch.isOn)
        }
    }
    
    func configure(withName name: String, type: TypesTableView.TypeRow) {
        nameLabel.text = name
        self.type = type
    }
    
    func configureWithState(_ state: Bool) {
        toggleSwitch.isOn = state
    }
}

// MARK: - UI Configuration
extension TypeCell {
    private func configureUI() {
        backgroundColor = .systemGray6
        selectionStyle = .none
        configureNameLabel()
        configureToggleSwitch()
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        nameLabel.pinLeft(to: leadingAnchor, 20)
        nameLabel.pinCenterY(to: centerYAnchor)
    }
    
    private func configureToggleSwitch() {
        contentView.addSubview(toggleSwitch)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        toggleSwitch.onTintColor = .customPink
        toggleSwitch.isUserInteractionEnabled = true
        toggleSwitch.addTarget(self, action: #selector(toggled), for: .valueChanged)
        
        toggleSwitch.pinRight(to: trailingAnchor, 20)
        toggleSwitch.pinCenterY(to: centerYAnchor)
    }
}
