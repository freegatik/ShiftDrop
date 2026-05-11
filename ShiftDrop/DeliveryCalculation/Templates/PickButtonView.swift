//
//  PickButtonView.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 14.05.2025.
//

import UIKit
import SnapKit

enum ButtonType {
    case shippedFromCity
    case shippedToCity
    case packageSize
}

protocol PickButtonViewDelegate: AnyObject {
    func didTapButton(type: ButtonType)
    func didSelectPoint(type: ButtonType, point: String)
}

class PickButtonView: UIView {
    
    weak var delegate: PickButtonViewDelegate?
    
    private let buttonType: ButtonType
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "TextSecondaryColor")
        return label
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(named: "BorderLightColor")?.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "TextSecondaryColor")
        return label
    }()
    
    private let chevron: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "chevron-down.pdf"))
        return imageView
    }()
    
    private let clickableWords: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private var selectedPoint: String?
    
    init(buttonType: ButtonType) {
        self.buttonType = buttonType
        super.init(frame: .zero)
        configurePickButtonView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePickButtonView() {
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        self.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.height.equalTo(40)
        }
        
        button.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.leading.equalTo(button.snp.leading).inset(12)
            make.centerY.equalTo(button)
        }
        
        button.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.leading).inset(24)
            make.centerY.equalTo(button)
        }
        
        button.addSubview(chevron)
        chevron.snp.makeConstraints { make in
            make.trailing.equalTo(button.snp.trailing).inset(12)
            make.centerY.equalTo(button)
        }
        
        self.addSubview(clickableWords)
        clickableWords.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(4)
            make.leading.bottom.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setIcon(icon: UIImage?) {
        self.icon.image = icon
    }
    
    func setValue(_ title: String) {
        valueLabel.text = title
    }

    /// Surface for `@testable` unit tests (seed values and user edits).
    var testDisplayedValue: String { valueLabel.text ?? "" }
    
    func setClickableWords(_ words: [String]) {
        for view in clickableWords.arrangedSubviews {
            clickableWords.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for word in words {
            let label = UILabel()
            let attributedText = NSAttributedString(string: word, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
            label.attributedText = attributedText
            label.textColor = UIColor(named: "TextTertiaryColor")
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(wordTapped(_:)))
            label.addGestureRecognizer(tapGesture)
            clickableWords.addArrangedSubview(label)
        }
    }
    
    @objc private func buttonTapped() {
        delegate?.didTapButton(type: buttonType)
    }
    
    @objc private func wordTapped(_ sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel, let text = label.text {
            selectedPoint = text
            delegate?.didSelectPoint(type: buttonType, point: text)
        }
    }
}
