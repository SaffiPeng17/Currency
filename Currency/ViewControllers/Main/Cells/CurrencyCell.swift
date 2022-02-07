//
//  CurrencyCell.swift
//  Currency
//
//  Created by Saffi on 2022/1/29.
//

import UIKit
import RxSwift

class CurrencyCell: BaseTableViewCell<CurrencyCellVM> {

    private lazy var background: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    private lazy var flag: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var currencyName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    private lazy var exchangeRate: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        currencyName.text = ""
        exchangeRate.text = ""
    }

    override func setupViews() {
        super.setupViews()

        selectionStyle = .none

        addSubview(background)
        background.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(-10)
        }

        background.addSubview(flag)
        background.addSubview(currencyName)
        background.addSubview(exchangeRate)
        flag.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
        }

        currencyName.snp.makeConstraints { make in
            make.leading.equalTo(flag.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }

        exchangeRate.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.centerY.equalToSuperview()
        }
    }

    override func bindViewModel() {
        super.bindViewModel()

        viewModel.backgroundColor.distinctUntilChanged().bind(to: background.rx.backgroundColor).disposed(by: disposeBag)
        viewModel.flagImage.distinctUntilChanged().bind(to: flag.rx.image).disposed(by: disposeBag)
        viewModel.countryTitle.distinctUntilChanged().bind(to: currencyName.rx.text).disposed(by: disposeBag)
        viewModel.exchangeRate.distinctUntilChanged().bind(to: exchangeRate.rx.text).disposed(by: disposeBag)
    }
}
