//
//  SenderViewController.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 24.05.2025.
//

import UIKit
import SnapKit

class SenderViewController: BaseViewController, ButtonViewDelegate {
    
    init(dependencies: AppDependencies, deliveryInformation: DeliveryInformation) {
        let headerView: HeaderView = {
            let headerView = HeaderView()
            headerView.setTitle("Отправитель")
            return headerView
        }()
        
        super.init(dependencies: dependencies, iconImage: "arrow-left.pdf", headerView: headerView, deliveryInformation: deliveryInformation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var surnameView: TextFieldView = {
        let surnameView = TextFieldView()
        surnameView.setPlaceHolder("Фамилия")
        return surnameView
    }()
    
    var nameView: TextFieldView = {
        let nameView = TextFieldView()
        nameView.setPlaceHolder("Имя")
        return nameView
    }()
    
    var patronymicView: TextFieldView = {
        let patronymicView = TextFieldView()
        patronymicView.setPlaceHolder("Отчество (при наличии)")
        return patronymicView
    }()
    
    var phoneNumberView: TextFieldView = {
        let phoneNumberView = TextFieldView()
        phoneNumberView.setPlaceHolder("Телефон")
        return phoneNumberView
    }()
    
    var buttonView: ButtonView = {
        let buttonView = ButtonView()
        buttonView.setButtonTitle("Продолжить")
        return buttonView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        buttonView.delegate = self
        
        self.view.addSubview(surnameView)
        configureSurnameView()
        
        self.view.addSubview(nameView)
        configureNameView()
        
        self.view.addSubview(patronymicView)
        configurePatronymicView()
        
        self.view.addSubview(phoneNumberView)
        configurePhoneNumberView()
        
        self.view.addSubview(buttonView)
        configureButtonView()
    }
    
    func configureSurnameView() {
        self.surnameView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
        }
    }
    
    func configureNameView() {
        self.nameView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(surnameView.snp.bottom)
        }
    }
    
    func configurePatronymicView() {
        self.patronymicView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(nameView.snp.bottom)
        }
    }
    
    func configurePhoneNumberView() {
        self.phoneNumberView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(patronymicView.snp.bottom)
        }
    }
    
    func configureButtonView() {
        self.buttonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(phoneNumberView.snp.bottom).offset(24)
        }
    }
    
    func didTapButton(in view: ButtonView) {
        if validateInputs() {
            let sender = Person(name: nameView.textField.text ?? "",
                                surname: surnameView.textField.text ?? "",
                                patronymic: patronymicView.textField.text ?? "",
                                phoneNumber: phoneNumberView.textField.text ?? "", street: "", house: "")
            deliveryInformation.sender = sender
            let whereToPickUpViewController = WhereToPickUpViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
            navigationController?.pushViewController(whereToPickUpViewController, animated: true)
        }
        
        else {
            if (!validateSurname()) {
                surnameView.textField.text = ""
            }
            if (!validateName()) {
                nameView.textField.text = ""
            }
            if (!validatePatronymic()) {
                patronymicView.textField.text = ""
            }
            if (!validatePhoneNumber()) {
                phoneNumberView.textField.text = ""
            }
            let alert = UIAlertController(title: "Ошибка в заполнении данных", message: "Неправильно заполненные поля были очищены", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func validateInputs() -> Bool {
        return validateSurname() && validateName() && validatePatronymic() && validatePhoneNumber()
    }
    
    func validateSurname() -> Bool {
        let surname = surnameView.textField.text ?? ""
        let regex = "^[А-Яа-яЁёA-Za-z\\s`'-]{1,60}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: surname)
    }
    
    func validateName() -> Bool {
        let name = nameView.textField.text ?? ""
        let regex = "^[А-Яа-яЁёA-Za-z\\s`'-]{1,60}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: name)
    }
    
    func validatePatronymic() -> Bool {
        let patronymic = patronymicView.textField.text ?? ""
        let regex = "^[А-Яа-яЁёA-Za-z\\s`'-]{0,60}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: patronymic)
    }
    
    func validatePhoneNumber() -> Bool {
        let phoneNumber = phoneNumberView.textField.text ?? ""
        let regex = "^[0-9]{11}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phoneNumber)
    }
    
    override func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
