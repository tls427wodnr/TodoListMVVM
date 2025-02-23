//
//  TableViewCell.swift
//  TodoListMVVM
//
//  Created by tlswo on 2/23/25.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var id : Int?
    
    var checkButton = UIButton()
    var titleLabel = UILabel()
    var dateLabel = UILabel()
    var deleteButton = UIButton()
    var verticalStackView = UIStackView()
    var horizontalStackView = UIStackView()
    
    var onCheckButtonTapped: ((Int) -> Void)?
    var onDeleteButtonTapped: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        checkButton.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(dateLabel)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 16
        horizontalStackView.addArrangedSubview(checkButton)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(deleteButton)
        
        contentView.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
        ])
    }
    
    @objc func didTapCheckButton() {
        guard let id = self.id else { return }
        onCheckButtonTapped?(id)
    }
    
    @objc func didTapDeleteButton() {
        guard let id = self.id else { return }
        onDeleteButtonTapped?(id)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    func set(id: Int,isDone: Bool,title: String, date: Date){
        self.id = id
        checkButton.setImage(UIImage(systemName: isDone ? "checkmark.circle.fill" : "circle"), for: .normal)
        titleLabel.text = title
        dateLabel.text = formatDate(date)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
    }
}
