//
//  TextFieldView.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 13.05.2025.
//

import UIKit

class TextFieldView: UIView {
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor(named: "TextPrimaryColor")
        textField.font = .systemFont(ofSize: 16)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "BorderLightColor")?.cgColor
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextFieldView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTextFieldView()
    }
    
    private func configureTextFieldView() {
        
        self.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.rightViewMode = .always
    }
    
    func setPlaceHolder(_ placeholder: String) {
        textField.placeholder = placeholder
    }
}
