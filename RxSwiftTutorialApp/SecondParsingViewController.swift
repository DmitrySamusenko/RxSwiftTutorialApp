//
//  SecondParsingViewController.swift
//  RxSwiftTutorialApp
//
//  Created by Dmitry Samusenko on 04.02.2024.
//

import UIKit
import RxSwift
import RxCocoa

struct CoinbaseInfo: Decodable {
    let data: [Datum]
}

struct Datum: Decodable {
    let id: String
    let symbol: String
    let priceUsd: String
}

class SecondParsingViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private var parsingData = BehaviorSubject(value: [Datum]())
    private var stringURL = "https://api.coincap.io/v2/assets"
    
    private var tableView: UITableView = {
       let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        bindRx()
        self.title = "Crypto Base (rxSwift)"
    }
  
}

extension SecondParsingViewController {
    private func setupUI() {
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
        self.tableView.frame = self.view.bounds
    }
    
    private func fetchData() {
        let url = URL(string: stringURL)
        guard let safetyURL = url else {
            return
        }
        let task = URLSession.shared.dataTask(with: safetyURL) { data, response, error in
            guard let data = data else {
                print("Error #1")
                return
            }
            do {
                let responseData = try JSONDecoder().decode(CoinbaseInfo.self, from: data)
                dump(responseData.data)
                self.parsingData.on(.next(responseData.data))
            } catch {
                print("Error #2")
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    private func bindRx() {
        parsingData.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, item, cell in
            cell.textLabel?.text = item.id.uppercased()
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Datum.self).bind { item in
            let vc = CryptoDetailViewController()
            vc.tickerLabelText.accept(item.symbol)
            vc.nameLabelText.accept(item.id.uppercased())
            vc.priceLabelText.accept("\(String(format: "%.2f",Double(item.priceUsd) ?? 0.0))" + " $")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        .disposed(by: disposeBag)
    }
    
}
