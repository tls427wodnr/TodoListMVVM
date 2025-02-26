//
//  ViewController.swift
//  TodoListMVVM
//
//  Created by tlswo on 2/23/25.
//

import UIKit

class MainViewController: UIViewController {
        
    private let todoViewModel = TodoViewModel()
    private var tableView: TableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupTableView()
        setupNavigatioinBar()
    }
    
    func setupNavigatioinBar(){
        title = "TodoList"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func setupTableView(){
        tableView = TableView(frame: view.bounds, viewModel: todoViewModel)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        tableView.onAddButtonTapped = { [weak self] title in
            let todos = self?.todoViewModel.getTodos()
            let maxId = todos?.max(by: { $0.id < $1.id })?.id ?? 0
            let date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            let todo = Todo(id: maxId + 1, title: title, date: date, isDone: false)
            self?.todoViewModel.addTodo(todo)
        }
    }
    
    @objc func addItem() {
        let alert = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                self?.tableView.onAddButtonTapped?(text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addTextField()
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

