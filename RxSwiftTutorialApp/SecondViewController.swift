//
//  SecondViewController.swift
//  RxSwiftTutorialApp
//
//  Created by Dmitry Samusenko on 17.01.2024.
//

import UIKit
import RxSwift
import RxCocoa

class SecondViewController: UIViewController {

    var label: UILabel = {
        let label = UILabel()
        label.text = "RxCocoa!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var textField: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //RxSubjects:
    
    var names = BehaviorRelay(value: ["Ann"])
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        names.asObservable().debug()
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .filter({ value in
                value.count > 1
            }).map({ value in
                value.joined(separator: ", ")
            })
            .subscribe(onNext: { [weak self] value in
            self?.label.text = value
            
        }).disposed(by: bag)
        
        
        setupUI()
        view.backgroundColor = .yellow
        
        names.accept(["Demetrius", "Crock"])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.names.accept(["Cool! RxSwift rules!", "Hey!"])
        }
    }
    
    private func setupUI() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate( [
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
   

}
