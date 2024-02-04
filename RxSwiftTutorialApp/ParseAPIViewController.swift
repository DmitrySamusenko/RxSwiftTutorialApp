//
//  ParseAPIViewController.swift
//  RxSwiftTutorialApp
//
//  Created by Dmitry Samusenko on 01.02.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ParseAPIViewController: UIViewController {
    private var disposeBag = DisposeBag()
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    private var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        viewModel.fetchUserElements()
        bindRxTableView()
        title = "RxSwift Parse API"
    }
    private func bindRxTableView() {
        viewModel.user.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, item, cell) in
            cell.textLabel?.text = item.title
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(UserElement.self).bind { element in
            let vc = ParseDetailViewController()
            //vc.label.text = element.body
            vc.descriptionText.accept(element.body)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

class ViewModel {
    var user = BehaviorSubject(value: [UserElement]())

    func fetchUserElements() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let responseData = try JSONDecoder().decode([UserElement].self, from: data)
                self.user.on(.next(responseData))
            } catch {
                print(error.localizedDescription)
            }
        }
            task.resume()
    }
}

struct UserElement: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}


