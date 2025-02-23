//
//  TableView.swift
//  TodoListMVVM
//
//  Created by tlswo on 2/23/25.
//

import UIKit

class TableView: UIViewController {
    
    private let todoViewModel = TodoViewModel()
    private let tableView = UITableView()
    
    var onAddButtonTapped: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        todoViewModel.onTodosUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func addNewTodo(title: String){
        let todos = todoViewModel.getTodos()
        let maxId = todos.max(by: { $0.id < $1.id })?.id ?? 0
        let date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let todo = Todo(id: maxId + 1, title: title, date: date, isDone: false)
        todoViewModel.addTodo(todo)
    }
}

extension TableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let todos = todoViewModel.getTodos()
        if section == 0 {
            return todos.filter { !$0.isDone }.count
        } else {
            return todos.filter { $0.isDone }.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Not Done" : "Done"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        var todos = todoViewModel.getTodos().sorted(by: { $0.id > $1.id })
        if indexPath.section == 0 {
            todos = todos.filter { !$0.isDone }
        } else {
            todos = todos.filter { $0.isDone }
        }
        let todo = todos[indexPath.row]
        cell.set(id: todo.id, isDone: todo.isDone, title: todo.title, date: todo.date)
        cell.onCheckButtonTapped = { [weak self] id in
            guard var todo = self?.todoViewModel.todo(withId: id) else { return }
            todo.isDone.toggle()
            self?.todoViewModel.updateTodo(todo)
        }
        cell.onDeleteButtonTapped = { [weak self] id in
            self?.todoViewModel.removeTodo(withId: id)
        }
        return cell
    }
}

extension TableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var todos = todoViewModel.getTodos()
        if indexPath.section == 0 {
            todos = todos.filter { !$0.isDone }
        } else {
            todos = todos.filter { $0.isDone }
        }
        print("\(todos[indexPath.row].title)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
