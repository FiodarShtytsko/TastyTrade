//
//  WathclistTableViewHeader.swift
//  TastyTrade
//
//  Created by Fiodar Shtytsko on 18/12/2023.
//

import UIKit

protocol WatchlistTableViewModelable {
    var id: String { get }
    var name: String { get }
    var tapWatchlist: () -> Void { get }
}

struct WatchlistTableViewModel: WatchlistTableViewModelable {
    let id: String
    let name: String
    var tapWatchlist: () -> Void
}

final class WatchlistTableViewHeader: UITableViewHeaderFooterView {
    
    private var label = UILabel()
    private var tapWatchlistAction: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
    }
    
    func configure(with watchlist: WatchlistTableViewModelable) {
        label.text = watchlist.name
        tapWatchlistAction = watchlist.tapWatchlist
    }
    
    @objc private func handleTap() {
        tapWatchlistAction?()
    }
}
