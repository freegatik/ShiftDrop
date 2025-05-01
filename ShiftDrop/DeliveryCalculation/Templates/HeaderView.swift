//
//  HeaderView.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 12.05.2025.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(named: "TextPrimaryColor")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHeaderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureHeaderView()
    }
    
    private func configureHeaderView() {
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
