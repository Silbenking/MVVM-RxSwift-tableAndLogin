//
//  ViewModel.swift
//  MVVM+rxSwift
//
//  Created by Сергей Сырбу on 05.02.2024.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class ViewModel {
    var users = BehaviorSubject(value: [SectionModel(model: "", items: [User]())])
    
    func fetchUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {return}
            do{
                let decoder = JSONDecoder()
                let posts = try decoder.decode([User].self, from: data)
                let sectionUsers = SectionModel(model: "First", items: [User(userID: 0, id: 1, title: "title", body: "body")])
                let secondSection = SectionModel(model: "Second", items: posts)
                self.users.on(.next([sectionUsers, secondSection]))
//                self.users.on(.next(posts))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    func addUser(user: User) {
        guard var section = try? users.value() else {return}
       var currentSection = section[0]
        currentSection.items.append(User(userID: 0, id: 1,title: "title", body: "body"))
        section[0] = currentSection
        self.users.onNext(section)
    }


    func deleteUser(indexPath: IndexPath) { // удаление ячейки
        guard var section = try? users.value() else {return} // попытки извлечения значения из массива пользователей с помощью try?
        var currentSection = section[indexPath.section] // содержит текущий раздел (section) в массиве пользователей, соответствующий выбранному IndexPath.
        currentSection.items.remove(at: indexPath.row) //удаляется элемент из текущего раздела currentSection по указанному IndexPath.
        section[indexPath.section] = currentSection //  обновляется значение массива пользователей, заменяя соответствующий раздел на измененный currentSection.
        self.users.onNext(section) // метод onNext(), чтобы сохранить обновленное значение массива пользователей.
    }

    func editUser(title: String, indexPath: IndexPath) { //изменение ячейки
        guard var section = try? users.value() else {return}
        var currentSection = section[indexPath.section]
        currentSection.items[indexPath.row].title = title
        section[indexPath.section] = currentSection 
        self.users.on(.next(section))
        
    }
// без dataSource
    //    func addUser(user: User) {
    //        guard var users = try? users.value() else {return}
    ////        users.insert(user, at: 0)
    ////        self.users.on(.next(users))
    //    }
//    func deleteUser(index: Int) { // удаление ячейки
//        guard var users = try? users.value() else {return} // попытки извлечения значения из массива пользователей с помощью try?
////        users.remove(at: index)// удаление из массива
////        self.users.on(.next(users)) //обновляем данные в пользовательском интерфейсе, вызывая метод on(.next(users)) для обновления данных в users.
//    }
    
//    func editUser(title: String, index: Int) {
//        guard var users = try? users.value() else {return}
////        users[index].title = title
////        self.users.on(.next(users))
//        
//    }
}
