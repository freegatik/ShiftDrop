//
//  WhereToDeliverReplicViewController.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 29.05.2025.
//

import UIKit
import SnapKit

class WhereToDeliverReplicViewController: BaseViewController, ButtonViewDelegate {
    
    init(dependencies: AppDependencies, deliveryInformation: DeliveryInformation) {
        let headerView: HeaderView = {
            let headerView = HeaderView()
            headerView.setTitle("Куда доставить")
            return headerView
        }()
        
        super.init(dependencies: dependencies, iconImage: "arrow-left.pdf", headerView: headerView, deliveryInformation: deliveryInformation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var streetView: TextFieldView = {
        let streetView = TextFieldView()
        streetView.setPlaceHolder("Улица")
        return streetView
    }()
    
    var houseView: TextFieldView = {
        let houseView = TextFieldView()
        houseView.setPlaceHolder("Дом")
        return houseView
    }()
    
    var roomNumberView: TextFieldView = {
        let roomNumberView = TextFieldView()
        roomNumberView.setPlaceHolder("Квартира")
        return roomNumberView
    }()
    
    var noteView: TextFieldView = {
        let noteView = TextFieldView()
        noteView.setPlaceHolder("Заметка для курьера (необязательно)")
        return noteView
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
        
        self.view.addSubview(streetView)
        configureStreetView()
        
        self.view.addSubview(houseView)
        configureHouseView()
        
        self.view.addSubview(roomNumberView)
        configureRoomNumberView()
        
        self.view.addSubview(noteView)
        configureNoteView()
        
        self.view.addSubview(buttonView)
        configureButtonView()
    }
    
    func configureStreetView() {
        self.streetView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
        }
    }
    
    func configureHouseView() {
        self.houseView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(streetView.snp.bottom)
        }
    }
    
    func configureRoomNumberView() {
        self.roomNumberView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(houseView.snp.bottom)
        }
    }
    
    func configureNoteView() {
        self.noteView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(roomNumberView.snp.bottom)
        }
    }
    
    func configureButtonView() {
        self.buttonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(noteView.snp.bottom).offset(24)
        }
    }
    
    func didTapButton(in view: ButtonView) {
        if validateInputs() {
            deliveryInformation.receiver?.house = houseView.textField.text ?? ""
            deliveryInformation.receiver?.street = streetView.textField.text ?? ""
            deliveryInformation.receiver?.roomNumber = roomNumberView.textField.text
            deliveryInformation.receiver?.note = noteView.textField.text ?? ""
            dismiss(animated: true)
        }
        
        else {
            if (!validateStreet()) {
                streetView.textField.text = ""
            }
            if (!validateHouse()) {
                houseView.textField.text = ""
            }
            if (!validateRoomNumber()) {
                roomNumberView.textField.text = ""
            }
            if (!validateNote()) {
                noteView.textField.text = ""
            }
            let alert = UIAlertController(title: "Ошибка в заполнении данных", message: "Неправильно заполненные поля были очищены", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func validateInputs() -> Bool {
        return validateStreet() && validateHouse() && validateRoomNumber() && validateNote()
    }
    
    func validateStreet() -> Bool {
        let street = streetView.textField.text ?? ""
        let regex = "^[А-Яа-яЁёA-Za-z0-9\\s\\-/'`:;_#,.]{1,100}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: street)
    }
    
    func validateHouse() -> Bool {
        let house = houseView.textField.text ?? ""
        let regex = "^[А-Яа-яЁёA-Za-z0-9\\s\\-/'`:;_#,.]{1,100}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: house)
    }
    
    func validateRoomNumber() -> Bool {
        let roomNumber = roomNumberView.textField.text ?? ""
        let regex = "^[А-Яа-яЁёA-Za-z0-9\\s\\-/'`:;_#,.]{1,100}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: roomNumber)
    }
    
    func validateNote() -> Bool {
        let note = noteView.textField.text ?? ""
        let regex = "^[А-Яа-яЁёA-Za-z0-9\\s\\-/'`:;_#,.]{0,100}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: note)
    }
    
    override func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
