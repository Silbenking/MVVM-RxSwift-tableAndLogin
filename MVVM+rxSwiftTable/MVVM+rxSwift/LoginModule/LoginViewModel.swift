//
//  LoginViewModule.swift
//  MVVM+rxSwift
//
//  Created by Сергей Сырбу on 09.02.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    var email: BehaviorSubject<String> = BehaviorSubject(value: "")
    var password: BehaviorSubject<String> = BehaviorSubject(value: "")

    var isValidEmail: Observable<Bool> {
        email.map {$0.isValidEmail()
        }
    }
    var isValidPassword: Observable<Bool> {
        return password.map { password in
            return password.count < 6 ? false:true
        }
    }
    var isValidInput: Observable<Bool> {
        return Observable.combineLatest(isValidEmail, isValidPassword).map { $0 && $1}
        }
    }


extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern:
            "[a-zA-Z0-9._]+@[a-z0-9._]+\\.[a-zA-Z]{2,64}", options: .caseInsensitive
        )
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
 
}
