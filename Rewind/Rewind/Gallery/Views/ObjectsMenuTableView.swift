//
//  ObjectsMenuTableView.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 09.03.2024.
//

import UIKit

final class ObjectsMenuTableView: UITableView {
    
    enum ObjectRow: String, CaseIterable {
        case photo = "New photo"
        case quote = "New quote"
    }
    
    var selectedRow: ((ObjectRow) -> Void)?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        delegate = self
        dataSource = self
        
        register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        isScrollEnabled = false
        rowHeight = 40
        showsVerticalScrollIndicator = true
        showsHorizontalScrollIndicator = false
        
        let height = Double((ObjectRow.allCases.count) * Int(rowHeight))
        setHeight(height)
        setWidth(UIScreen.main.bounds.width / 2)
    }
}

extension ObjectsMenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ObjectRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ObjectRow.allCases[indexPath.row].rawValue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return cell
    }
}


extension ObjectsMenuTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = ObjectRow.allCases[indexPath.row]
        selectedRow?(row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
