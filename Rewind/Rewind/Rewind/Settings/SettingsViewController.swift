//
//  SettingsViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 04.03.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    var presenter: SettingsPresenter?
    
    private let titleLabel: UILabel = UILabel()
    private let typesTable: TypesTableView = TypesTableView()
    private let propertiesTable: PropertiesTableView = PropertiesTableView()
    private let fromLabel: UILabel = UILabel()
    private let fromDatePicker: UIDatePicker = UIDatePicker()
    private let toLabel: UILabel = UILabel()
    private let toDatePicker: UIDatePicker = UIDatePicker()
    private let tagsCollection: TagsCollectionView = TagsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension SettingsViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        configureTitleLabel()
        configureTypesTable()
        configurePropertiesTable()
        
        configureFromLabel()
        configureFromDatePicker()
        
        configureToDatePicker()
        configureToLabel()
        
        configureTagsCollection()
        
        configureContinueButton()
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Random object settings"
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        titleLabel.pinCenterX(to: view.centerXAnchor)
    }
    
    private func configureTypesTable() {
        view.addSubview(typesTable)
        typesTable.translatesAutoresizingMaskIntoConstraints = false
        
        typesTable.pinTop(to: titleLabel.bottomAnchor, 25)
        typesTable.pinLeft(to: view.leadingAnchor, 20)
        typesTable.pinRight(to: view.trailingAnchor, 20)
    }
    
    private func configurePropertiesTable() {
        view.addSubview(propertiesTable)
        propertiesTable.translatesAutoresizingMaskIntoConstraints = false
        
        propertiesTable.pinTop(to: typesTable.bottomAnchor, 10)
        propertiesTable.pinLeft(to: view.leadingAnchor, 20)
        propertiesTable.pinRight(to: view.trailingAnchor, 20)
    }
    
    private func configureFromLabel() {
        view.addSubview(fromLabel)
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        
        fromLabel.text = "From"
        fromLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        fromLabel.pinTop(to: propertiesTable.bottomAnchor, 30)
        fromLabel.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureFromDatePicker() {
        view.addSubview(fromDatePicker)
        fromDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        fromDatePicker.datePickerMode = .date
        fromDatePicker.tintColor = .customPink
        
        fromDatePicker.pinCenterY(to: fromLabel.centerYAnchor)
        fromDatePicker.pinLeft(to: fromLabel.trailingAnchor, 10)
    }
    
    private func configureToLabel() {
        view.addSubview(toLabel)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        
        toLabel.text = "To"
        toLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        toLabel.pinTop(to: propertiesTable.bottomAnchor, 30)
        toLabel.pinRight(to: toDatePicker.leadingAnchor, 20)
    }
    
    private func configureToDatePicker() {
        view.addSubview(toDatePicker)
        toDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        toDatePicker.datePickerMode = .date
        toDatePicker.tintColor = .customPink
        
        toDatePicker.pinCenterY(to: fromLabel.centerYAnchor)
        toDatePicker.pinRight(to: view.trailingAnchor, 20)
    }
    
    private func configureTagsCollection() {
        view.addSubview(tagsCollection)
        tagsCollection.translatesAutoresizingMaskIntoConstraints = false
        
        tagsCollection.setHeight(200)
        tagsCollection.pinTop(to: toDatePicker.bottomAnchor, 30)
        tagsCollection.pinLeft(to: view.leadingAnchor, 20)
        tagsCollection.pinRight(to: view.trailingAnchor, 20)
    }
    
    private func configureContinueButton() {
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.customPink, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        continueButton.layer.borderColor = UIColor.customPink.cgColor
        continueButton.layer.borderWidth = 4
        continueButton.layer.cornerRadius = 30
        
//        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        continueButton.pinBottom(to: view.bottomAnchor, 50)
        continueButton.pinCenterX(to: view.centerXAnchor)
        continueButton.setHeight(60)
        continueButton.setWidth(200)
    }
}
