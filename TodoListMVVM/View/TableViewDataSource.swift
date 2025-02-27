//
//  TableViewDataSource.swift
//  TodoListMVVM
//
//  Created by tlswo on 2/27/25.
//

import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var todoViewModel: TodoViewModel
    
    init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    private func filteredTodos(for section: Int) -> [Todo] {
        let todos = todoViewModel.getTodos()
        if section == 0 {
            return todos.filter { !$0.isDone }
        } else {
            return todos.filter { $0.isDone }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTodos(for: section).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Not Done" : "Done"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let todos = filteredTodos(for: indexPath.section).sorted(by: { $0.id > $1.id })
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todos = filteredTodos(for: indexPath.section)
        print("\(todos[indexPath.row].title)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
