//
//  ColorsTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class ColorsTableView: UITableView {
    
    enum ColorRow: String, CaseIterable {
        case backgroundColor = "Background color"
        case textColor = "Quote color"
        
        var color: UIColor {
            switch self {
            case .backgroundColor:
                return .white
            case .textColor:
                return .customPink
            }
        }
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
}

extension ColorsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ColorRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let customCell = cell as? ColorCell else { return cell }
        let title = ColorRow.allCases[indexPath.row].rawValue
        let color = ColorRow.allCases[indexPath.row].color
        customCell.configure(withTitle: title, color: color)
        return customCell
    }
}

extension ColorsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
