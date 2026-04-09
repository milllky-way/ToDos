//
//  ListItemViewController.swift
//  ToDos
//
//  Created by Дарья Саитова on 09.04.2026.
//

import UIKit

protocol ListItemDisplayLogic: UIViewController {
    func display(title: String)
    func display(text: String)
    func displaySaving()
}

protocol ListItemViewControllerDelegate: UIViewController {
    func itemDidSave()
}

final class ListItemViewController: UIViewController {
    weak var delegate: ListItemViewControllerDelegate?
    
    private let interactor: ListItemBusinessLogic
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20)
        textView.textColor = .label
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return textView
    }()
    
    init(interactor: ListItemBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTextView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let saveItem = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(save)
        )
        navigationItem.rightBarButtonItem = saveItem
        interactor.setTitle()
    }
    
    private func setupTextView() {
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        interactor.setText()
    }
    
    @objc private func save() {
        interactor.saveItem(with: textView.text)
    }
}

extension ListItemViewController: ListItemDisplayLogic {
    func display(title: String) {
        navigationItem.title = title
    }
    
    func display(text: String) {
        textView.text = text
    }
    
    func displaySaving() {
        dismiss(animated: true) {
            self.delegate?.itemDidSave()
        }
    }
}
