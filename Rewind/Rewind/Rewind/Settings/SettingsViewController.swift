//
//  SettingsViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 04.03.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    var presenter: SettingsPresenter?
    
    var viewDistanceTop: CGFloat = 40
    var rewindVC: RewindViewController?
    
    private let titleLabel: UILabel = UILabel()
    private let typesTable: TypesTableView = TypesTableView()
    private let propertiesTable: PropertiesTableView = PropertiesTableView()
    private let continueButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typesTable.presenter = presenter
        propertiesTable.presenter = presenter
        presenter?.typesTable = typesTable
        presenter?.propertiesTable = propertiesTable
        configureUI()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter?.configureUIForFilter()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        view.frame.size.height = UIScreen.main.bounds.height - viewDistanceTop
        view.frame.origin.y = viewDistanceTop
        view.layer.cornerRadius = 20
    }
    
    @objc
    private func continueButtonTapped() {
        presenter?.continueButtonTapped()
    }
}

extension SettingsViewController {
    private func configureUI() {
        view.backgroundColor = .systemGray5
        
        configureTitleLabel()
        configureTypesTable()
        configurePropertiesTable()
        
        configureContinueButton()
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Random object settings"
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 50)
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
    
    private func configureContinueButton() {
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.customPink, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        continueButton.layer.borderColor = UIColor.customPink.cgColor
        continueButton.layer.borderWidth = 4
        continueButton.layer.cornerRadius = 30
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        continueButton.pinTop(to: propertiesTable.bottomAnchor, 50)
        continueButton.pinCenterX(to: view.centerXAnchor)
        continueButton.setHeight(60)
        continueButton.setWidth(200)
    }
}

// MARK: - Private funcs
extension SettingsViewController {
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            break
        case .changed:
            let translation = gesture.translation(in: view)
            if view.frame.origin.y + translation.y >= viewDistanceTop {
                view.frame.origin.y += translation.y
                gesture.setTranslation(.zero, in: view)
            }
        case .ended:
            let velocity = gesture.velocity(in: view)
            let childViewHeight = UIScreen.main.bounds.height - viewDistanceTop
            if velocity.y > 0 && view.frame.origin.y > childViewHeight * 0.5 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin.y = UIScreen.main.bounds.height
                }) { _ in
                    self.dismiss(animated: false, completion: nil)
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin.y = self.viewDistanceTop
                }) { _ in
                    self.view.frame.origin.y = self.viewDistanceTop
                }
            }
        default:
            break
        }
    }
}
