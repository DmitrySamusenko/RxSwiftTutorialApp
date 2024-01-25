//
//  SixViewController.swift
//  RxSwiftTutorialApp
//
//  Created by Dmitry Samusenko on 25.01.2024.
//

import UIKit
import RxCocoa
import RxSwift

struct Moovie {
    var name: String
    var price: Int
}

struct SixModelView {
    var mooviesOnCinemas: PublishSubject = PublishSubject<[Moovie]>()
    
     func fetchMoovies() {
        let moovies = [
            Moovie(name: "Холоп 2", price: 250),
            Moovie(name: "Холодное сердце", price: 150),
            Moovie(name: "Три богатыря. На темных берегах", price: 250),
            Moovie(name: "Джон Уик 3", price: 250),
            Moovie(name: "Блэйд 2", price: 250)
            
        ]
        mooviesOnCinemas.onNext(moovies)
        mooviesOnCinemas.onCompleted()
    }
}

class SixViewController: UIViewController {
    //MARK: Variables
    private var modelView: SixModelView = SixModelView()
    let disposeBag = DisposeBag()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //modelView.fetchMoovies()
        
        setupUI()
        bindRx()
    }
    
    
    
}

extension SixViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = .clear
    }
    
    private func bindRx() {
        modelView.mooviesOnCinemas.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, model, cell in
            cell.textLabel?.text = model.name
        }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Moovie.self).bind { moovie in
            self.title = moovie.name
        }
        
        modelView.fetchMoovies()
    }
}
