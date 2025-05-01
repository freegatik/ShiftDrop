//
//  SuccessViewController.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 27.05.2025.
//

import UIKit
import SnapKit

class SuccessViewController: BaseViewController, ButtonViewDelegate {
    
    init(dependencies: AppDependencies, deliveryInformation: DeliveryInformation) {
        let headerView: HeaderView = {
            let headerView = HeaderView()
            headerView.setTitle("")
            return headerView
        }()
        
        super.init(dependencies: dependencies, iconImage: "cross.pdf", headerView: headerView, deliveryInformation: deliveryInformation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var icon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "success"))
        return icon
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Заявка отправлена"
        label.textColor = UIColor(named: "TextPrimaryColor")
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы можете оплатить ваш заказ в разделе «Профиль»"
        label.textColor = UIColor(named: "TextSecondaryColor")
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var buttonView: ButtonView = {
        let buttonView = ButtonView()
        buttonView.setButtonTitle("Посмотреть статус")
        return buttonView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        buttonView.delegate = self
        
        self.view.addSubview(icon)
        configureIcon()
        
        self.view.addSubview(titleLabel)
        configureTitleLabel()
        
        self.view.addSubview(textLabel)
        configureTextLabel()
        
        self.view.addSubview(buttonView)
        configureButtonView()
    }
    
    func configureIcon() {
        self.icon.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(154)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureTitleLabel() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureTextLabel() {
        self.textLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    func configureButtonView() {
        self.buttonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(textLabel.snp.bottom).offset(40)
        }
    }
    
    func didTapButton(in view: ButtonView) {
        let historyViewController = SecondViewController(dependencies: dependencies)
        navigationController?.pushViewController(historyViewController, animated: true)
    }
    
    override func leftBarButtonTapped() {
        dismiss(animated: true)
    }
}
