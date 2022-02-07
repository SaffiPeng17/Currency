//
//  BaseViewController.swift
//  Currency
//
//  Created by Saffi on 2022/1/27.
//

import Foundation
import UIKit
import RxSwift

protocol ViewControllerSetupProtocol {
    func setupNavigationBar()
    func setupViews()
    func setupBinding()
}

class BaseViewModel {
    init() {}
}

class BaseCoreViewController: UIViewController, ViewControllerSetupProtocol {

    var disposeBag = DisposeBag()

    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    deinit {
        print("\(type(of: self)):", #function)
    }

    // MARK: - ViewControllerSetupProtocol
    func setupNavigationBar() {
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
    }

    func setupViews() {}

    func setupBinding() {}
}

class BaseViewController<T: BaseViewModel>: BaseCoreViewController {

    private(set) var viewModel: T!

    required init(with viewModel: T) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
