//
//  CheckBoxView.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 14.05.2025.
//

import UIKit
import SnapKit

class CheckBoxView: UIView {
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.textColor = UIColor(named: "TextPrimaryColor")
        return label
    }()
    
    var isChosen: Bool
    private var toggleStateHandler: (() -> Void)?
    
    init(isChosen: Bool = false) {
        self.isChosen = isChosen
        super.init(frame: .zero)
        configureCheckBoxView()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCheckBoxView() {
        
        self.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(icon.snp.trailing).offset(16)
        }
        
        updateState()
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
        icon.addGestureRecognizer(tapGesture)
    }
    
    @objc private func iconTapped() {
        if (!self.isChosen) {
            setState(!isChosen)
            toggleStateHandler?()
        }
    }
    
    private func updateState() {
        if isChosen {
            setIcon(icon: UIImage(named: "checkbox-active.pdf"))
        } else {
            setIcon(icon: UIImage(named: "checkbox-inactive.pdf"))
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setIcon(icon: UIImage?) {
        self.icon.image = icon
    }
    
    func setState(_ chosen: Bool) {
        isChosen = chosen
        updateState()
    }
    
    func setToggleStateHandler(handler: (() -> Void)?) {
        self.toggleStateHandler = handler
    }
}
