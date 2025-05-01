//
//  WhoPayForDeliveryViewController.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 23.05.2025.
//

import UIKit

class WhoPayForDeliveryViewController: BaseViewController, ButtonViewDelegate {
    
    init(dependencies: AppDependencies, deliveryInformation: DeliveryInformation) {
        let headerView: HeaderView = {
            let headerView = HeaderView()
            headerView.setTitle("Оплата доставки")
            return headerView
        }()
        
        super.init(dependencies: dependencies, iconImage: "arrow-left.pdf", headerView: headerView, deliveryInformation: deliveryInformation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var buttonView: ButtonView = {
        let buttonView = ButtonView()
        buttonView.setButtonTitle("Продолжить")
        return buttonView
    }()
    
    var receiverCheckBoxView: CheckBoxView = {
        let receiverCheckBoxView = CheckBoxView()
        receiverCheckBoxView.setState(true)
        receiverCheckBoxView.setTitle("Получатель")
        return receiverCheckBoxView
    }()
    
    var senderCheckBoxView: CheckBoxView = {
        let senderCheckBoxView = CheckBoxView()
        senderCheckBoxView.setTitle("Отправитель")
        return senderCheckBoxView
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "Кто оплачивает доставку"
        label.textColor = UIColor(named: "TextPrimaryColor")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        buttonView.delegate = self
        
        self.view.addSubview(label)
        configureLabel()
        
        self.view.addSubview(receiverCheckBoxView)
        configureReceiverCheckBoxView()
        
        self.view.addSubview(senderCheckBoxView)
        configureSenderCheckBoxView()
        
        self.view.addSubview(buttonView)
        configureButtonView()
        
        receiverCheckBoxView.setToggleStateHandler { [weak self] in
            guard let self = self else { return }
            if self.receiverCheckBoxView.isChosen {
                self.senderCheckBoxView.setState(false)
            }
        }
        
        senderCheckBoxView.setToggleStateHandler { [weak self] in
            guard let self = self else { return }
            if self.senderCheckBoxView.isChosen {
                self.receiverCheckBoxView.setState(false)
            }
        }
    }
    
    func configureLabel() {
        self.label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
        }
    }
    
    func configureReceiverCheckBoxView() {
        self.receiverCheckBoxView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(label.snp.bottom).offset(24)
        }
    }
    
    func configureSenderCheckBoxView() {
        self.senderCheckBoxView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(receiverCheckBoxView.snp.bottom).offset(16)
        }
    }
    
    func configureButtonView() {
        self.buttonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(senderCheckBoxView.snp.bottom).offset(40)
        }
    }
    
    func didTapButton(in view: ButtonView) {
        
        if (receiverCheckBoxView.isChosen) {
            deliveryInformation.whoPay = "RECEIVER"
        }
        else {
            deliveryInformation.whoPay = "SENDER"
        }
        
        let dataCheckViewController = DataCheckViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
        navigationController?.pushViewController(dataCheckViewController, animated: true)
    }
    
    override func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
