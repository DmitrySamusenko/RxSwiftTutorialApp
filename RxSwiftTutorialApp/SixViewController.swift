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
    var movs = BehaviorRelay<[Moovie]>(value: [Moovie]())
    //var bhvrsbjc: BehaviorSubject = BehaviorSubject<[Moovie]>()
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
         
         movs.accept(moovies)
         
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
    
    private var searchBar: UISearchBar = {
       let sb = UISearchBar()
        sb.placeholder = "Enter the moovie name"
        return sb
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
        view.addSubview(searchBar)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        //tableView.frame = view.bounds
        tableView.backgroundColor = .clear
        
        NSLayoutConstraint.activate( [
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func bindRx() {
        
        modelView.fetchMoovies()
        let moovieQuery = searchBar.rx.text.orEmpty
            .throttle(.milliseconds(2), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { query in
                self.modelView.movs.value.filter { movie in
                    query.isEmpty || movie.name.lowercased().contains(query.lowercased())
                }
            }
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) {
                row, model, cell in
                cell.textLabel?.text = model.name
            }
            .disposed(by: disposeBag)
        
//        modelView.movs.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, model, cell in
//            cell.textLabel?.text = model.name
//        }
//            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Moovie.self).bind { moovie in
            self.title = moovie.name
            let vc = DetailSixViewController()
            vc.nameOfMoovie.accept(moovie.name)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        .disposed(by: disposeBag)
        
        modelView.fetchMoovies()
    }
}
