//
//  DetailSixViewController.swift
//  RxSwiftTutorialApp
//
//  Created by Dmitry Samusenko on 26.01.2024.
//

import UIKit
import RxSwift
import RxCocoa

class DetailSixViewController: UIViewController {
    let nameOfMoovie = BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    
     var titleLable: UILabel = {
       let label = UILabel()
        //label.text = "RxSwift Testing"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
         label.numberOfLines = 0
         label.textAlignment = .center
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(label: titleLable)
        bindRx()
    }


}
extension DetailSixViewController {
    private func setupUI(label: UILabel) {
        view.addSubview(label)
        view.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            label.widthAnchor.constraint(equalToConstant: 150),
            label.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func bindRx() {
        nameOfMoovie.bind(to: titleLable.rx.text)
            .disposed(by: disposeBag)
        
        
    }
}
