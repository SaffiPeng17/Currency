//
//  BaseTableViewCell.swift
//  Currency
//
//  Created by Saffi on 2022/1/29.
//

import UIKit
import RxSwift

protocol TableViewCellSetupProtocol: AnyObject {
    func setupViews()
    func setupViewModel(viewModel: BaseViewModel)
    func bindViewModel()
    func updateViews()
}

protocol CellViewModelProtocol {
    var cellIdentifier: String { get }
}

class BaseTableViewCellVM: BaseViewModel, CellViewModelProtocol {
    var cellIdentifier: String = "BaseTableViewCellVM"
}

class BaseTableViewCell<T: BaseTableViewCellVM>: UITableViewCell, TableViewCellSetupProtocol {

    var disposeBag = DisposeBag()

    private(set) var viewModel: T! {
        willSet {
            self.disposeBag = DisposeBag()
        }
        didSet {
            self.bindViewModel()
            self.updateViews()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(type(of: self)):", #function)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

    // MARK: TableViewCellSetupProtocol
    func setupViews() {}

    func setupViewModel(viewModel: BaseViewModel) {
        if let vm = viewModel as? T {
            self.viewModel = vm
        }
    }

    func bindViewModel() {}

    func updateViews() {}
}
