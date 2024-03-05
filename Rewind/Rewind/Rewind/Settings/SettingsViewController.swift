//
//  SettingsViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 04.03.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    var presenter: SettingsPresenter?
    
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let typesTable: TypesTableView = TypesTableView()
    private let propertiesTable: PropertiesTableView = PropertiesTableView()
    private let fromLabel: UILabel = UILabel()
    private let fromDatePicker: UIDatePicker = UIDatePicker()
    private let toLabel: UILabel = UILabel()
    private let toDatePicker: UIDatePicker = UIDatePicker()
    private let tagsLabel: UILabel = UILabel()
    private let tagsCollection: TagsCollectionView = TagsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

//    private let tagsTable: TagsTableView = TagsTableView()
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc
    private func continueButtonTapped() {
        presenter?.continueButtonTapped()
    }
}

extension SettingsViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        
        configureScrollView()
        configureContentView()
        
        configureTitleLabel()
        configureTypesTable()
        configurePropertiesTable()
        
        configureFromLabel()
        configureFromDatePicker()
        
        configureToDatePicker()
        configureToLabel()
        
        configureTagsLabel()
        configureTagsCollection()
//        configureTagsTable()
        
        configureContinueButton()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemGray5
        
        scrollView.pinLeft(to: view.leadingAnchor)
        scrollView.pinRight(to: view.trailingAnchor)
        scrollView.pinTop(to: view.topAnchor)
        scrollView.pinBottom(to: view.bottomAnchor)
    }
    
    private func configureContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .systemGray5
        
        contentView.pinLeft(to: scrollView.leadingAnchor)
        contentView.pinRight(to: scrollView.trailingAnchor)
        contentView.pinTop(to: scrollView.topAnchor)
        contentView.pinBottom(to: scrollView.bottomAnchor)
        contentView.pinWidth(to: scrollView.widthAnchor)
        contentView.setHeight(200 + 100 + 30 + 250 + 30 + 60 + 100)
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Random object settings"
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        titleLabel.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor, 20)
        titleLabel.pinCenterX(to: contentView.centerXAnchor)
    }
    
    private func configureTypesTable() {
        contentView.addSubview(typesTable)
        typesTable.translatesAutoresizingMaskIntoConstraints = false
        
        typesTable.pinTop(to: titleLabel.bottomAnchor, 25)
        typesTable.pinLeft(to: contentView.leadingAnchor, 20)
        typesTable.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configurePropertiesTable() {
        contentView.addSubview(propertiesTable)
        propertiesTable.translatesAutoresizingMaskIntoConstraints = false
        
        propertiesTable.pinTop(to: typesTable.bottomAnchor, 10)
        propertiesTable.pinLeft(to: contentView.leadingAnchor, 20)
        propertiesTable.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureFromLabel() {
        contentView.addSubview(fromLabel)
        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        
        fromLabel.text = "From"
        fromLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        fromLabel.pinTop(to: propertiesTable.bottomAnchor, 30)
        fromLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureFromDatePicker() {
        contentView.addSubview(fromDatePicker)
        fromDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        fromDatePicker.datePickerMode = .date
        fromDatePicker.tintColor = .customPink
        
        fromDatePicker.pinCenterY(to: fromLabel.centerYAnchor)
        fromDatePicker.pinLeft(to: fromLabel.trailingAnchor, 10)
    }
    
    private func configureToLabel() {
        contentView.addSubview(toLabel)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        
        toLabel.text = "To"
        toLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        toLabel.pinTop(to: propertiesTable.bottomAnchor, 30)
        toLabel.pinRight(to: toDatePicker.leadingAnchor, 20)
    }
    
    private func configureToDatePicker() {
        contentView.addSubview(toDatePicker)
        toDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        toDatePicker.datePickerMode = .date
        toDatePicker.tintColor = .customPink
        
        toDatePicker.pinCenterY(to: fromLabel.centerYAnchor)
        toDatePicker.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureTagsLabel() {
        contentView.addSubview(tagsLabel)
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: "Tags  5/10")
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 20, weight: .medium)], range: NSRange(location: 0, length: 4))
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium)], range: NSRange(location: 6, length: 4))
        tagsLabel.attributedText = attributedString
        
        tagsLabel.pinTop(to: fromLabel.bottomAnchor, 30)
        tagsLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureTagsCollection() {
        contentView.addSubview(tagsCollection)
        
        tagsCollection.delaysContentTouches = false
        tagsCollection.translatesAutoresizingMaskIntoConstraints = false
        
        tagsCollection.setHeight(200)
        tagsCollection.pinTop(to: tagsLabel.bottomAnchor, 10)
        tagsCollection.pinLeft(to: view.leadingAnchor, 20)
        tagsCollection.pinRight(to: view.trailingAnchor, 20)
    }
    
//    private func configureTagsTable() {
//        contentView.addSubview(tagsTable)
//        tagsTable.translatesAutoresizingMaskIntoConstraints = false
//        
//        tagsTable.pinTop(to: tagsLabel.bottomAnchor, 10)
////        tagsTable.pinBottom(to: continueButton.topAnchor, 30)
//        tagsTable.pinLeft(to: contentView.leadingAnchor, 20)
//        tagsTable.pinRight(to: contentView.trailingAnchor, 20)
//    }
    
    private func configureContinueButton() {
        contentView.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.customPink, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        continueButton.layer.borderColor = UIColor.customPink.cgColor
        continueButton.layer.borderWidth = 4
        continueButton.layer.cornerRadius = 30
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        continueButton.pinTop(to: tagsCollection.bottomAnchor, 20)
        continueButton.pinCenterX(to: contentView.centerXAnchor)
        continueButton.setHeight(60)
        continueButton.setWidth(200)
    }
}
