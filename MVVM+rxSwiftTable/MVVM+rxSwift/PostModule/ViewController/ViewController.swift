//
//  ViewController.swift
//  MVVM+rxSwift
//
//  Created by Сергей Сырбу on 05.02.2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ViewController: UIViewController, UIScrollViewDelegate {

    private let viewModel = ViewModel()
    private var db = DisposeBag()
    lazy var tableView: UITableView = {
        tableView = UITableView(frame: self.view.frame, style: .insetGrouped)
       tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
       tableView.translatesAutoresizingMaskIntoConstraints = false
       return tableView
   }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        navigation()
        viewModel.fetchUsers()
        bindTableView()
    }

    func navigation() {
        title = "users"
        let add = UIBarButtonItem(title: "add", style: .done, target: self, action: #selector(onTapAdd))
        self.navigationItem.rightBarButtonItem = add
    }

    @objc func onTapAdd() {
        let user = User(userID: 0, id: 0, title: "String")
        self.viewModel.addUser(user: user)
    }

    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: db) // передаем данные в ячейку
//        viewModel.users.bind(to: tableView.rx.items(cellIdentifier: "PostCell", cellType: PostCell.self)) {(row, item, cell) in
//            cell.textLabel?.text = item.title
//            cell.detailTextLabel?.text = "\(item.id!)"
//        }.disposed(by: db)
//
//        tableView.rx.itemSelected.subscribe { indexPath in // отслеживем нажатие на ячейку
//            let alert = UIAlertController(title: "Добавить юзера", message: "Введите текст", preferredStyle: .alert)
//            alert.addTextField { textField in
//                
//            }
//            let okAction = UIAlertAction(title: "Сохранить", style: .default) { text in
//                let textField = alert.textFields![0]
//                self.viewModel.editUser(title: textField.text ?? "", index: indexPath.row)
//            }
//            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
//            alert.addAction(okAction)
//            alert.addAction(cancelAction)
//            self.present(alert, animated: true)
//        }.disposed(by: db)
//        
//        tableView.rx.itemDeleted.subscribe { [weak self] indexPath in // удаление ячейки
//            guard let self = self else { return }
//            self.viewModel.deleteUser(index: indexPath.row)
//        }.disposed(by: db)

        // подключили фреймворк RxDataSources

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>> { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.id!)"
            return cell
        } titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model
        }
        self.viewModel.users.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: db)

        tableView.rx.itemDeleted.subscribe { [weak self] indexPath in // удаление ячейки
                  guard let self = self else { return }
                  self.viewModel.deleteUser(indexPath: indexPath)
              }.disposed(by: db)

        tableView.rx.itemSelected.subscribe { indexPath in // отслеживем нажатие на ячейку
                  let alert = UIAlertController(title: "Добавить юзера", message: "Введите текст", preferredStyle: .alert)
                  alert.addTextField { textField in
      
                  }
                  let okAction = UIAlertAction(title: "Сохранить", style: .default) { text in
                      let textField = alert.textFields![0]
                      self.viewModel.editUser(title: textField.text ?? "", indexPath: indexPath)
                  }
                  let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
                  alert.addAction(okAction)
                  alert.addAction(cancelAction)
                  self.present(alert, animated: true)
              }.disposed(by: db)
    }
}
