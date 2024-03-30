//
//  ColorsTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class ColorsTableView: UITableView {
    var presenter: AddQuotePresenter?
    
    enum ColorRow: String, CaseIterable {
        case backgroundColor = "Background color"
        case textColor = "Quote color"
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        dataSource = self
        delegate = self
        register(ColorCell.self, forCellReuseIdentifier: "cell")
        isScrollEnabled = false
        layer.cornerRadius = 20
        rowHeight = 50
        setHeight(Double(Int(rowHeight) * (ColorRow.allCases.count) - 1))
    }
    
    func configureUIForColor(_ selectedColor: UIColor, inRow row: ColorsTableView.ColorRow?) {
        switch row {
        case .backgroundColor:
            if let cell = cellForRow(at: IndexPath(row: 0, section: 0)) as? ColorCell {
                cell.configureWithColor(selectedColor)
            }
        case .textColor:
            if let cell = cellForRow(at: IndexPath(row: 1, section: 0)) as? ColorCell {
                cell.configureWithColor(selectedColor)
            }
        case nil:
            print("do nothing")
        }
    }
}

extension ColorsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ColorRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? ColorCell else { return cell }
        let title = ColorRow.allCases[indexPath.row].rawValue
        if indexPath.row == 0 {
            customCell.configure(withTitle: title, color: .systemGray6)
        } else if indexPath.row == 1 {
            customCell.configure(withTitle: title, color: .systemGray)
        }
        return customCell
    }
}

extension ColorsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            presenter?.rowSelected(.backgroundColor)
        } else if indexPath.row == 1 {
            presenter?.rowSelected(.textColor)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
