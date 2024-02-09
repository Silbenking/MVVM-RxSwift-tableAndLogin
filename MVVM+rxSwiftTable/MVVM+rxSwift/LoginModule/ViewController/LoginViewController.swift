//
//  LoginViewController.swift
//  MVVM+rxSwift
//
//  Created by Сергей Сырбу on 07.02.2024.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class LoginViewController: UIViewController {

    lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите почту"
        textField.keyboardType = .emailAddress
        textField.borderStyle = .line
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите пароль"
        textField.isSecureTextEntry = true
        textField.borderStyle = .line
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.textColor = .black
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(tapLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var db = DisposeBag()
    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createObservables()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        [loginButton, passwordTextField, loginTextField].forEach {view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            loginTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loginTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func tapLogin() {
        
    }

    private func createObservables() {
        loginTextField.rx.text.map {  $0 ?? "" }.bind(to: viewModel.email).disposed(by: db)// настраивает привязку текстового поля loginTextField к свойству email объекта viewModel.Она использует RxSwift для создания потока данных из текста в текстовом поле,
        passwordTextField.rx.text.map {$0 ?? ""}.bind(to: viewModel.password).disposed(by: db)
        
        viewModel.isValidInput.bind(to: loginButton.rx.isEnabled).disposed(by: db) //связывает состояние кнопки входа (loginButton) с isValidInput из объекта viewModel. Кнопка включается или отключается в зависимости от значения isValidInput.
        viewModel.isValidInput.subscribe(onNext: {[weak self] isValid in // создается подписка на изменения в isValidInput объекта viewModel. Когда значение изменяется, изменяется цвет фона кнопки входа (loginButton). Если isValid истинно, цвет фона устанавливается на .systemBlue, иначе на .systemRed
            self?.loginButton.backgroundColor = isValid ? .systemBlue: .systemRed
        }).disposed(by: db)
    }
}
