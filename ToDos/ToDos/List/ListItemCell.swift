//
//  ListItemCell.swift
//  ToDos
//
//  Created by Дарья Саитова on 07.04.2026.
//

import UIKit

/// `UITableView`-cell для отображения задачи (см. `ListItemViewModel`)
final class ListItemCell: UITableViewCell {
    static let reuseID = "ListItemCell"

    private let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemYellow
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let todoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        let textStackView = UIStackView(arrangedSubviews: [titleLabel, todoLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 6
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(checkboxButton)
        contentView.addSubview(textStackView)

        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            checkboxButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),

            textStackView.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with model: ListItemViewModel) {
        todoLabel.text = model.todo
        todoLabel.textColor = model.isCompleted ? .tertiaryLabel : .label
        let imageName = model.isCompleted ? "checkmark.circle.fill" : "circle"
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        checkboxButton.setImage(image, for: .normal)
        checkboxButton.tintColor = model.isCompleted ? .systemYellow : .systemGray2


        if model.isCompleted {
            let attributes: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.tertiaryLabel,
                .foregroundColor: UIColor.tertiaryLabel
            ]
            titleLabel.attributedText = NSAttributedString(string: model.title, attributes: attributes)
        } else {
            titleLabel.attributedText = nil
            titleLabel.text = model.title
            titleLabel.textColor = .label
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        titleLabel.text = nil
        todoLabel.text = nil
    }
}
