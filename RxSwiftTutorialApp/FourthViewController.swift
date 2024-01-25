//
//  FourthViewController.swift
//  RxSwiftTutorialApp
//
//  Created by Dmitry Samusenko on 20.01.2024.
//

import UIKit
import RxSwift
import RxCocoa
struct Person {
    var name: String
    var age: Int
}

struct ModelView {
     func fetchPerson() -> [Person] {
        return [
            Person(name: "Harry", age: 12),
            Person(name: "Dmitry", age: 29),
            Person(name: "Markus", age: 86),
            Person(name: "Drew", age: 45),
        ]
    }
}

class FourthViewController: UIViewController {
    private var modelView = ModelView()
    private var disposeBag = DisposeBag()
    private var persons: [Person]?
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        persons = modelView.fetchPerson()
        setupUI()
        bindRxSwift()
        
        
    }
    private func setupUI() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        tableView.frame = view.bounds
        title = "New RxSwift Test Table (#4)"
    }

   

}

extension FourthViewController {
    private func bindRxSwift() {
        let personsItems = Observable.just(persons!)
        
        personsItems.bind(to: tableView.rx.items(cellIdentifier: "cell")) {
            (tv, item, cell) in
            cell.textLabel?.text = item.name
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Person.self).bind {
            person in
            self.title = person.name
        }
        .disposed(by: disposeBag)
    }
}
