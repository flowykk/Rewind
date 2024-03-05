////
////  TagsTableView.swift
////  Rewind
////
////  Created by Aleksa Khruleva on 05.03.2024.
////
//
//import UIKit
//
//final class TagsTableView: UITableView {
//    var tags: [String] = ["tag1", "tag2", "tag3", "tag4", "tag5"]
//    
//    override init(frame: CGRect, style: UITableView.Style) {
//        super.init(frame: frame, style: style)
//        commonInit()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func commonInit() {
//        delegate = self
//        dataSource = self
//        register(TagCell.self, forCellReuseIdentifier: "cell")
//        
//        backgroundColor = .systemGray5
//        isScrollEnabled = false
//        layer.cornerRadius = 20
//        rowHeight = 50
//        showsVerticalScrollIndicator = false
//        showsHorizontalScrollIndicator = false
//        
//        let height = tags.count > 0 ? (Int(rowHeight) * tags.count - 1) : 0
//        setHeight(Double(height))
//    }
//    
//    func configure(withTags tags: [String]) {
//        self.tags = tags
//    }
//}
//
//// MARK: - UITableViewDataSource
//extension TagsTableView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tags.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        guard let customCell = cell as? TagCell else { return cell }
//        let name = tags[indexPath.row]
//        customCell.configure(withName: name)
//        return customCell
//    }
//}
//
//// MARK: - UITableViewDataSource
//extension TagsTableView: UITableViewDelegate { }
