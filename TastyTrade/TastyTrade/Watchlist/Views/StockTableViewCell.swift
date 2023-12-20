//
//  StockTableViewCell.swift
//  TastyTrade
//
//  Created by Fiodar Shtytsko on 18/12/2023.
//

import UIKit

protocol StockTableViewModelable {
    var symbol: String { get }
    var bidPrice: String { get }
    var askPrice: String { get }
    var lastPrice: String { get }
}

struct StockTableViewModel: StockTableViewModelable {
    var symbol: String
    var bidPrice: String
    var askPrice: String
    var lastPrice: String
}

final class StockTableViewCell: UITableViewCell {
    
    private let stackView = UIStackView()
    private let symbolLabel = UILabel()
    private let bidPriceLabel = UILabel()
    private let askPriceLabel = UILabel()
    private let lastPriceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }

    private func setupCell() {
        setupStackView()
        setupLabels()
        layoutViews()
    }

    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        addSubview(stackView)
    }

    private func setupLabels() {
        [symbolLabel, bidPriceLabel, askPriceLabel, lastPriceLabel].forEach { label in
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
    }

    private func layoutViews() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configure(with stock: StockTableViewModelable) {
        symbolLabel.text = stock.symbol
        bidPriceLabel.text = stock.bidPrice
        askPriceLabel.text = stock.askPrice
        lastPriceLabel.text = stock.lastPrice
    }
}
