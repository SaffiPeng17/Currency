//
//  LoadingView.swift
//  Currency
//
//  Created by Saffi on 2022/2/8.
//

import UIKit
import Lottie

class LoadingView: UIView {

    static let shared: LoadingView = {
        let view = LoadingView(frame: UIScreen.main.bounds)
        view.isHidden = true
        return view
    }()

    private lazy var animation: AnimationView = {
        let view = AnimationView(name: "65705-spinner")
        view.loopMode = .loop
        return view
    }()

    private var refCount = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        frame = UIScreen.main.bounds
        backgroundColor = UIColor(hex: 0x000000, alpha: 0.7)
        isHidden = true

        addSubview(animation)

        animation.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(96)
        }

        window.addSubview(self)
    }

    func show() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        refCount += 1
        guard refCount <= 1 else {
            return
        }
        animation.play()
        isHidden = false

        window.bringSubviewToFront(self)
    }

    func hide() {
        refCount -= 1
        guard refCount <= 0 else {
            return
        }
        animation.stop()
        isHidden = true
        refCount = 0
    }
}
