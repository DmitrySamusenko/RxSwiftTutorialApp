//
//  TestParseViewController.swift
//  RxSwiftTutorialApp
//
//  Created by Dmitry Samusenko on 03.02.2024.
//

import UIKit
import RxCocoa
import RxSwift

//RickAndMorty API

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let characters = try? JSONDecoder().decode(Characters.self, from: jsonData)
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let characters = try? JSONDecoder().decode(Characters.self, from: jsonData)

import Foundation

// MARK: - Characters
struct Characters: Decodable {
    //  let info: Info
    let results: [Result]
}

// MARK: - Info
struct Info: Decodable {
    let count, pages: Int
    let next: String
    //let prev: NSNull
}

struct Result: Decodable {
    let name: String
}






struct Comments: Decodable {
    //let userId, id: Int
    let title, body: String
}

struct BlogPost: Decodable {
    var title: String
    var url: URL
}

class TestParseViewController: UIViewController {
    var posts = BehaviorSubject(value: [Result]())
    let disposeBag = DisposeBag()
    let stringURL = "https://rickandmortyapi.com/api/character"
    
    private var tableView: UITableView = {
       let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        jsonParse()
        bindRx()
    }
 
}

extension TestParseViewController {
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.frame = self.view.bounds
    }
    
    private func jsonParse() {
       let url = URL(string: stringURL)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                print("1")
                dump(data)
                print(error?.localizedDescription)
                return
                
            }
            do {
                let responseData = try JSONDecoder().decode(Characters.self, from: data)
                //print(responseData.info)
                
                dump(responseData.results[0].name)
                self.posts.on(.next(responseData.results))
                
            } catch {
                print("2")
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    private func bindRx() {
        posts.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, item, cell in
            cell.textLabel?.text = item.name
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Result.self).bind { item in
            self.title = item.name
            
        }
        .disposed(by: disposeBag)
    }
}
