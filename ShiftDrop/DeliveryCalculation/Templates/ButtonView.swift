//
//  ButtonView.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 13.05.2025.
//

import UIKit
import SnapKit

protocol ButtonViewDelegate: AnyObject {
    func didTapButton(in view: ButtonView)
}

class ButtonView: UIView {
    
    weak var delegate: ButtonViewDelegate?
    
    private var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "ButtonColor")
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 30
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButtonView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureButtonView()
    }
    
    private func configureButtonView() {
        
        self.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setButtonTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    
    @objc private func buttonTapped() {
        delegate?.didTapButton(in: self)
    }
}
