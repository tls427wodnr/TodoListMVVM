//
//  TableView.swift
//  TodoListMVVM
//
//  Created by tlswo on 2/23/25.
//

import UIKit

class TableView: UIView {
    
    private let tableView = UITableView()
    private var dataSource: TableViewDataSource
        
    init(frame: CGRect, viewModel: TodoViewModel) {
        self.dataSource = TableViewDataSource(todoViewModel: viewModel)
        super.init(frame: frame)
        setupTableView()
        
        viewModel.onTodosUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        addSubview(tableView)
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.rowHeight = 100
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
