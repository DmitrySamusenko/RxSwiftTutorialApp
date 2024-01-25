//
//  FivethViewController.swift
//  RxSwiftTutorialApp
//
//  Created by Dmitry Samusenko on 21.01.2024.
//

import UIKit
import RxCocoa
import RxSwift

struct FiveModelView {
    var items = PublishSubject<[String]>()
    
    func fetchItems() {
        let products = [
            "Milk",
            "Potato",
            "Watermelon",
            "Cucumber"
        ]
        items.onNext(products)
        //items.onCompleted()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let names = [
                "Demetrius",
                "Brutes",
                "Cezar",
                "Livius"
            ]
            items.onNext(names)
            items.onCompleted()
        }
    }
}

class FivethViewController: UIViewController {
    private var modelView: FiveModelView = FiveModelView()
    private var modelViewDetail = ModelViewDetail()
    private var disposeBag = DisposeBag()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindTableDataRx()
    }
    
}

extension FivethViewController {
    private func setupUI() {
        title = "RxCocoa"
        view.backgroundColor = .systemPink
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = .clear
        
    }
    private func bindTableDataRx() {
        //Bind data to Table
        
        modelViewDetail.symbolObjects.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
            cell.backgroundColor = .clear
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Simbols.self).bind { item in
            self.title = item.title
            let dtv = DetailFivethViewController()
            dtv.imageName.accept(item.imageName)
            //dtv.imageView.image = UIImage(systemName: item.imageName)
            self.navigationController?.pushViewController(dtv, animated: true)
        }
        .disposed(by: disposeBag)
        modelView.fetchItems()
        modelViewDetail.fetch()
    }
}
