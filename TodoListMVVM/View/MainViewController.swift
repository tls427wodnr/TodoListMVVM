//
//  ViewController.swift
//  TodoListMVVM
//
//  Created by tlswo on 2/23/25.
//

import UIKit

class MainViewController: UIViewController {
        
    let tableView = TableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(tableView)
        view.addSubview(tableView.view)
        tableView.didMove(toParent: self)
        
        title = "TodoList"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.rightBarButtonItem = addButton
        
        tableView.onAddButtonTapped = { [weak self] title in
            self?.tableView.addNewTodo(title: title)
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

