//
//  PointTableViewCell.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 20.05.2025.
//

import UIKit
import SnapKit

class PointTableViewCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = UIColor(named: "TextPrimaryColor")
        return nameLabel
    }()
    
    private let iconImage: UIImageView = {
        let iconImage = UIImageView(image: UIImage(named: "arrow-right.pdf"))
        return iconImage
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
        
        self.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with point: Point) {
        nameLabel.text = point.name
    }
}
