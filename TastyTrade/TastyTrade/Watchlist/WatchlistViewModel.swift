//
//  WatchlistViewModel.swift
//  TastyTrade
//
//  Created by Fiodar Shtytsko on 18/12/2023.
//

import Foundation

protocol WatchlistViewModelable {
    var stocks: [StockTableViewModelable] { get }
    var watchlists: [WatchlistTableViewModelable] { get }
    var tapWatchlist: (() -> Void)? { get set }
    var manageWatchlists: (() -> Void)? { get set }
    var onStocksUpdated: (() -> Void)? { get set }

    var indexSelectedWatchlist: Int { get }
    
    func load()
    func addNewWatchlist(with name: String)
    func selectWatchList(with id: String)
    func deleteWatchlist(with id: String)

}

final class WatchlistViewModel: WatchlistViewModelable {
    
    var tapWatchlist: (() -> Void)?
    var manageWatchlists: (() -> Void)?
    var onStocksUpdated: (() -> Void)?
    
    private(set) var watchlists: [WatchlistTableViewModelable] {
        didSet { onStocksUpdated?() }
    }
    private(set) var stocks: [StockTableViewModelable] {
        didSet { onStocksUpdated?() }
    }
    
    private(set) var indexSelectedWatchlist: Int {
        didSet { onStocksUpdated?() }
    }

    init(stocks: [StockTableViewModelable]) {
        self.stocks = stocks
        indexSelectedWatchlist = 0
        self.watchlists = []
    }
}

extension WatchlistViewModel {
    func load() {
        for i in 0..<5 {
            stocks.append(StockTableViewModel(symbol: "GOOGL \(i)",
                                              bidPrice: String(format: "%.2f", Double(i)),
                                              askPrice: String(format: "%.2f", Double(i)),
                                              lastPrice: String(format: "%.2f", Double(i))))
        }
        
        for i in 0..<5 {
            watchlists.append(WatchlistTableViewModel(id: String(i),
                                                      name: "watchlists \(i)",
                                                      tapWatchlist: tapWatchlist!))
        }
    }
    
    func selectWatchList(with id: String) {
        guard let index = watchlists.firstIndex(where: { $0.id == id } ) else { return }
        indexSelectedWatchlist = index
    }
    
    func deleteWatchlist(with id: String) {
        guard let index = watchlists.firstIndex(where: { $0.id == id } ) else { return  }
        watchlists.remove(at: index)
        indexSelectedWatchlist = 0
    }
    
    func addNewWatchlist(with name: String) {
        watchlists.append(WatchlistTableViewModel(id: String(watchlists.count + 1),
                                                  name: name,
                                                  tapWatchlist: tapWatchlist!))
    }
}
