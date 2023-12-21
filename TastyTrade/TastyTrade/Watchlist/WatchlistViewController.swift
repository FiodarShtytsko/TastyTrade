//
//  WatchlistViewController.swift
//  TastyTrade
//
//  Created by Fiodar Shtytsko on 17/12/2023.
//

import UIKit

final class WatchlistViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private var viewModel: WatchlistViewModelable!
    private var searchController: UISearchController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = WatchlistViewModel(stocks: [])
        setupViewController()
        setupViewModelBindings()
        viewModel.load()
    }
    
    private func setupViewController() {
        setupTableView()
        setupSearchController()
        setupNavigationItems()
        setupRefreshControl()
    }
    
    private func setupViewModelBindings() {
        viewModel.onStocksUpdated = { [weak self] in self?.tableView.reloadData() }
        viewModel.tapWatchlist = { [weak self] in self?.handleTapWatchlist() }
        viewModel.manageWatchlists = { [weak self] in self?.handleManageWatchlists() }
    }
    
    private func handleTapWatchlist() {
        showDropdownWatchlists { [weak self] id in
            self?.viewModel.selectWatchList(with: id)
        }
    }
    
    private func handleManageWatchlists() {
        showDropdownWatchlists { [weak self] id in
            self?.viewModel.deleteWatchlist(with: id)
        }
    }
        
    private func setupTableView() {
        tableView.register(StockTableViewCell.self,
                           forCellReuseIdentifier: StockTableViewCell.description())
        tableView.register(WatchlistTableViewHeader.self,
                           forHeaderFooterViewReuseIdentifier: WatchlistTableViewHeader.description())
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Symbols"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl = refreshControl
    }
    
    
    @objc private func addButtonTapped() {
        presentManageWatchlistsActionSheet()
    }

    @objc private func refreshData() {
        refreshControl.endRefreshing()
    }
}

extension WatchlistViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.stocks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.description(), for: indexPath) as! StockTableViewCell
        cell.configure(with: model)
        return cell
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = viewModel.watchlists[viewModel.indexSelectedWatchlist]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: WatchlistTableViewHeader.description()) as! WatchlistTableViewHeader
        header.configure(with: model)
        return header
    }
}

extension WatchlistViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        // Update search results logic
    }
}

extension WatchlistViewController {
    private func presentManageWatchlistsActionSheet() {
        let actions: [(String, UIAlertAction.Style, (UIAlertAction) -> Void)] = [
            ("Add new", .default, { [weak self] _ in self?.presentWatchlistNameEntryAlert() }),
            ("Delete Watchlist", .default, { [weak self] _ in self?.viewModel.manageWatchlists?() }),
            ("Cancel", .cancel, { _ in })
        ]
        presentActionSheet(title: "Watchlists", actions: actions)
    }
    
    private func presentWatchlistNameEntryAlert() {
        let alertController = UIAlertController(title: "Enter Name", message: "", preferredStyle: .alert)
        alertController.addTextField { $0.placeholder = "Name" }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let name = alertController.textFields?.first?.text else { return }
            self?.viewModel.addNewWatchlist(with: name)
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }

    @objc func showDropdownWatchlists(handler: @escaping (String) -> ()) {
        let actions = viewModel.watchlists.map { watchlist -> (String, UIAlertAction.Style, ((UIAlertAction) -> Void)?) in
            return (watchlist.name, .default, { _ in handler(watchlist.id) })
        }
        
        let cancelAction = ("Cancel", UIAlertAction.Style.cancel, nil as ((UIAlertAction) -> Void)?)
        presentActionSheet(title: "Watchlists", actions: actions + [cancelAction])
    }

    private func presentActionSheet(title: String, actions: [(String, UIAlertAction.Style, ((UIAlertAction) -> Void)?)]) {
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        actions.forEach { (title, style, action) in
            let alertAction = UIAlertAction(title: title, style: style) { action?($0) }
            actionSheet.addAction(alertAction)
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
}
