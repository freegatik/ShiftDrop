//
//  PackageTableViewCell.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 20.05.2025.
//

import UIKit
import SnapKit

class PackageTableViewCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = UIColor(named: "TextSecondaryColor")
        return nameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurePointTableViewCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurePointTableViewCell()
    }
    
    private func configurePointTableViewCell() {
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().offset(16)
        }
    }
    
    func configure(with point: Point) {
        nameLabel.text = point.name
    }
}
