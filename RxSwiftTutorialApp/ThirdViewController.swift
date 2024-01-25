//
//  ThirdViewController.swift
//  RxSwiftTutorialApp
//
//  Created by Dmitry Samusenko on 19.01.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ThirdViewController: UIViewController {
    
     let arrayOfNames = [
        "Demetrius",
        "Alex",
        "Markcus",
        "Giovani"
    ]
    let disposeBag = DisposeBag()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindRxSwiftObjects()
    
    }
    
    
    
    
}


extension ThirdViewController {
    private func setupUI() {
        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.frame = view.bounds
        title = "RxSwift"
    }
}
extension ThirdViewController {
    private func bindRxSwiftObjects() {
        let tableViewItems = Observable.just(arrayOfNames)
        
        tableViewItems.bind(to: tableView.rx.items(cellIdentifier: "cell")) {
            (tv, tableViewItem, cell) in
            cell.textLabel?.text = tableViewItem
        }
        .disposed(by: disposeBag)
    }
  
    
    
}
