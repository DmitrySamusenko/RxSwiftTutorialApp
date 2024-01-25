//
//  DetailFivethViewController.swift
//  RxSwiftTutorialApp
//
//  Created by Dmitry Samusenko on 21.01.2024.
//

import UIKit
import RxSwift
import RxCocoa

struct Simbols {
    var title: String
    var imageName: String
}

struct ModelViewDetail {
    let symbolObjects = PublishSubject<[Simbols]>()
    func fetch() {
        let symbols = [
            Simbols(title: "Home", imageName: "house.fill"),
            Simbols(title: "Walking", imageName: "figure.walk.arrival"),
            Simbols(title: "Home", imageName: "house.fill"),
            Simbols(title: "Home", imageName: "house.fill"),
            Simbols(title: "Home", imageName: "house.fill"),
            Simbols(title: "Home", imageName: "house.fill"),
            Simbols(title: "Home", imageName: "house.fill"),
            Simbols(title: "Home", imageName: "house.fill"),
            Simbols(title: "Home", imageName: "house.fill"),
            Simbols(title: "Home", imageName: "house.fill")
        ]
        symbolObjects.onNext(symbols)
        symbolObjects.onCompleted()
    }
}

class DetailFivethViewController: UIViewController {
    
    let imageName = BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    
     var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindRx()
    }
}

extension DetailFivethViewController {
    private func setupUI() {
        view.addSubview(imageView)
        
        view.backgroundColor = .white
        NSLayoutConstraint.activate( [
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func bindRx() {
        imageName.map { name in
            UIImage.init(systemName: name)
        }
        .bind(to: imageView
            .rx
            .image)
        .disposed(by: disposeBag)
    }
}
