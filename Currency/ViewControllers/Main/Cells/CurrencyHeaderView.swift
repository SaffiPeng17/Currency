//
//  CurrencyHeaderView.swift
//  Currency
//
//  Created by Saffi on 2022/1/30.
//

import UIKit

class CurrencyHeaderView: UITableViewHeaderFooterView {

    var content: String = "" {
        didSet {
            dayTitle.text = content
        }
    }

    private lazy var dayTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        contentView.addSubview(dayTitle)

        dayTitle.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
}
