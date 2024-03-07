//
//  MemberCell.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 07.03.2024.
//

import UIKit

final class MemberCell: UITableViewCell {
    
    private let buttonImageView: UIImageView = UIImageView()
    private let buttonLabel: UILabel = UILabel()
    
    private let memberImageView: UIImageView = UIImageView()
    private let memberNameLabel: UILabel = UILabel()
    
    private let ownerSignImageView: UIImageView = UIImageView()
    
    private let deleteMemberButton: UIButton = UIButton(type: .system)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let left = 12 + UIScreen.main.bounds.width * 0.09 + 12
        separatorInset = UIEdgeInsets(top: .zero, left: left, bottom: .zero, right: .zero)
    }
    
    func configureButton(_ button: MembersTableView.MembersButton) {
        buttonLabel.text = button.rawValue
        configureButtonImageView(imageName: button.imageName)
        configureButtonLabel()
    }
    
    func configureMember(name: String, type: MembersTableView.MemberType) {
        memberNameLabel.text = name
        configureMemberImageView()
        configureMemberNameLabel()
        if type == .owner {
            configureOwnerSign()
        } else if type == .member {
            configureDeleteMemberButton()
        }
    }
}

extension MemberCell {
    private func configureUI() {
        backgroundColor = .systemGray6
    }
    
    private func configureMemberImageView() {
        addSubview(memberImageView)
        memberImageView.translatesAutoresizingMaskIntoConstraints = false
        
        memberImageView.image = UIImage(named: "member")
        
        memberImageView.contentMode = .scaleAspectFill
        memberImageView.clipsToBounds = true
        
        let width = UIScreen.main.bounds.width * 0.09
        
        memberImageView.layer.cornerRadius = width / 2
        
        memberImageView.setWidth(width)
        memberImageView.setHeight(width)
        memberImageView.pinLeft(to: leadingAnchor, 12)
        memberImageView.pinCenterY(to: centerYAnchor)
    }
    
    private func configureMemberNameLabel() {
        addSubview(memberNameLabel)
        memberNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        memberNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        memberNameLabel.pinLeft(to: memberImageView.trailingAnchor, 12)
        memberNameLabel.pinCenterY(to: centerYAnchor)
    }
    
    private func configureOwnerSign() {
        addSubview(ownerSignImageView)
        ownerSignImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let configuration = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: "star.fill", withConfiguration: configuration)
        image = image?.withTintColor(.customPink, renderingMode: .alwaysOriginal)
        ownerSignImageView.image = image
        
        ownerSignImageView.pinRight(to: trailingAnchor, 12)
        ownerSignImageView.pinCenterY(to: centerYAnchor)
    }
    
    private func configureDeleteMemberButton() {
        contentView.addSubview(deleteMemberButton)
        deleteMemberButton.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 12, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: "xmark", withConfiguration: configuration)
        image = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        deleteMemberButton.setImage(image, for: .normal)
        
        let side = self.frame.size.height / 2
        deleteMemberButton.setWidth(side)
        deleteMemberButton.setHeight(side)
        deleteMemberButton.pinRight(to: trailingAnchor, 12)
        deleteMemberButton.pinCenterY(to: centerYAnchor)
    }
    
    private func configureButtonImageView(imageName: String) {
        addSubview(buttonImageView)
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonImageView.contentMode = .center
        
        let font = UIFont.systemFont(ofSize: 20, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: font)
        var image = UIImage(systemName: imageName, withConfiguration: configuration)
        image = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        buttonImageView.image = image
        
        let width = UIScreen.main.bounds.width * 0.09
        
        buttonImageView.layer.cornerRadius = width / 2
        
        buttonImageView.setWidth(width)
        buttonImageView.pinLeft(to: leadingAnchor, 12)
        buttonImageView.pinCenterY(to: centerYAnchor)
    }
    
    private func configureButtonLabel() {
        addSubview(buttonLabel)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        buttonLabel.pinLeft(to: buttonImageView.trailingAnchor, 12)
        buttonLabel.pinCenterY(to: centerYAnchor)
    }
}
