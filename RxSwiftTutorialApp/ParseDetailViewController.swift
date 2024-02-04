//
//  ParseDetailViewController.swift
//  RxSwiftTutorialApp
//
//  Created by Dmitry Samusenko on 03.02.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ParseDetailViewController: UIViewController {
    var descriptionText: BehaviorRelay = BehaviorRelay(value: "")
    let disposeBag = DisposeBag()
    
     var label: UILabel = {
       let label = UILabel()
        label.textColor = .black
        //label.text = "RxSwift testing Detail Page"
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindRx()
    }
}

extension ParseDetailViewController {
    private func setupUI() {
        self.view.addSubview(label)
        self.view.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func bindRx() {
        descriptionText.bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.descriptionText.accept("Text after 5 seconds")
        }
    }
}
