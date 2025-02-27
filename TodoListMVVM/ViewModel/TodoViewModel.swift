//
//  TableViewViewModel.swift
//  TodoListMVVM
//
//  Created by tlswo on 2/23/25.
//

import Foundation

class TodoViewModel {
    var onTodosUpdated: (() -> Void)?
    
    private var todos: [Todo] = [] {
        didSet {
            onTodosUpdated?()
        }
    }
    
    func getTodos() -> [Todo] {
        return todos
    }
    
    func todo(withId id: Int) -> Todo? {
        return todos.first(where: { $0.id == id })
    }
    
    func addTodo(title: String) {
        let maxId = todos.max(by: { $0.id < $1.id })?.id ?? 0
        let date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let todo = Todo(id: maxId + 1, title: title, date: date, isDone: false)
        todos.append(todo)
        onTodosUpdated?()
    }
    
    func removeTodo(withId id: Int) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos.remove(at: index)
            onTodosUpdated?()
        }
    }
    
    func updateTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            onTodosUpdated?()
        }
    }
}
