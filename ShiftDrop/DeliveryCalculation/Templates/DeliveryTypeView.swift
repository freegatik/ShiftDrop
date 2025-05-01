//
//  DeliveryTypeView.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 15.05.2025.
//

import UIKit
import SnapKit

enum DeliveryType {
    case express
    case usual
}

protocol DeliveryTypeViewDelegate: AnyObject {
    func didTapButton(type: DeliveryType)
}

class DeliveryTypeView: UIView {
    
    weak var delegate: DeliveryTypeViewDelegate?
    
    private let deliveryType: DeliveryType
    
    private var button: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(named: "BorderExtraLightColor")?.cgColor
        button.layer.cornerRadius = 24
        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "TextTertiaryColor")
        return label
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let arrowRight: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrow-right.pdf"))
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "TextPrimaryColor")
        return label
    }()
    
    private let deliveryTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "TextTertiaryColor")
        return label
    }()
    
    init(deliveryType: DeliveryType) {
        self.deliveryType = deliveryType
        super.init(frame: .zero)
        configureDeliveryTypeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDeliveryTypeView() {
        
        self.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(120)
        }
        
        button.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        button.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(icon.snp.trailing).offset(16)
        }
        
        button.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(icon.snp.trailing).offset(16)
        }
        
        button.addSubview(arrowRight)
        arrowRight.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(16)
        }
        
        button.addSubview(deliveryTimeLabel)
        deliveryTimeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(icon.snp.trailing).offset(16)
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setIcon(icon: UIImage?) {
        self.icon.image = icon
    }
    
    func setPrice(_ title: String) {
        priceLabel.text = title
        priceLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    func setDeliveryTime(_ title: String) {
        deliveryTimeLabel.text = title
    }
    
    
    @objc private func buttonTapped() {
        delegate?.didTapButton(type: deliveryType)
    }
}
