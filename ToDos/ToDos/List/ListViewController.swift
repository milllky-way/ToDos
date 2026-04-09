//
//  ListViewController.swift
//  ToDos
//
//  Created by Дарья Саитова on 02.04.2026.
//

import UIKit

/// Интерфейс View-части экрана списка задач.
protocol ListDisplayLogic: UIViewController {
    func displayLoadingState()
    func displayList(_ viewModel: ListViewModel)
}

final class ListViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<ListSection, ListItemViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ListSection, ListItemViewModel>
    
    private let interactor: ListBusinessLogic
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: ListItemCell.reuseID) as? ListItemCell
            else {
                return UITableViewCell()
            }
            cell.configure(with: item)
            return cell
        }
        return dataSource
    }()

    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    private let activityIndicatorView = UIActivityIndicatorView()
    
    init(interactor: ListBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
        setupActivityIndicatorView()
        setupToolbar()
        interactor.loadList()
    }

    private func setupNavigationBar() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(ListItemCell.self, forCellReuseIdentifier: ListItemCell.reuseID)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupActivityIndicatorView() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupToolbar() {
        navigationController?.isToolbarHidden = false
        let counterItem = UIBarButtonItem(customView: counterLabel)
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(addTaskTapped)
        )
        toolbarItems = [counterItem, addButton]
    }

    @objc private func addTaskTapped() {
        interactor.addItem()
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        interactor.setItem(completed: !item.isCompleted, id: item.id)
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return UIContextMenuConfiguration() }
        return UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: nil
        ) { [weak interactor] _ in
            let editAction = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "square.and.pencil")
            ) { _ in
                interactor?.editItem(with: item.id)
            }
            
            let shareAction = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { _ in
                interactor?.shareItem(with: item.id)
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                interactor?.deleteItem(with: item.id)
            }
            
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}

// MARK: - ListDisplayLogic

extension ListViewController: ListDisplayLogic {
    func displayLoadingState() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func displayList(_ viewModel: ListViewModel) {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        counterLabel.text = viewModel.toolbarText
        counterLabel.sizeToFit()
    }
}

// MARK: - UISearchResultsUpdating

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        interactor.updateSearchResults(for: searchController.searchBar.text ?? "")
    }
}

// MARK: - Mock

final class ListDisplayLogicMock: UIViewController, ListDisplayLogic {
    var displayLoadingStateWasCalled = 0
     
    func displayLoadingState() {
        displayLoadingStateWasCalled += 1
    }
    
    var displayListWasCalled = 0
    var displayListReceivedViewModel: ListViewModel?
    
    func displayList(_ viewModel: ListViewModel) {
        displayListWasCalled += 1
        displayListReceivedViewModel = viewModel
    }
}
