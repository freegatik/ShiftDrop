//
//  DataCardView.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 15.05.2025.
//

import UIKit
import SnapKit

enum DataCardType {
    case receiver
    case sender
    case senderPoint
    case receiverPoint
}

protocol DataCardViewDelegate: AnyObject {
    func didTapIcon(type: DataCardType)
}

class DataCardView: UIView {
    
    weak var delegate: DataCardViewDelegate?
    
    private let dataCardType: DataCardType
    
    private var cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = UIColor(named: "BGSecondaryColor")
        cardView.layer.cornerRadius = 16
        return cardView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.textColor = UIColor(named: "TextPrimaryColor")
        return label
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pencil"))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var firstSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor(named: "TextTertiaryColor")
        label.numberOfLines = 0
        return label
    }()
    
    private var firstDataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = UIColor(named: "TextPrimaryColor")
        label.numberOfLines = 0
        return label
    }()
    
    private var secondSubTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor(named: "TextTertiaryColor")
        label.numberOfLines = 0
        return label
    }()
    
    private var secondDataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = UIColor(named: "TextPrimaryColor")
        label.numberOfLines = 0
        return label
    }()
    
    init(dataCardType: DataCardType) {
        self.dataCardType = dataCardType
        super.init(frame: .zero)
        configureDataCardView()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDataCardView() {
        
        self.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(24)
        }
        
        cardView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(24)
        }
        
        cardView.addSubview(firstSubTitleLabel)
        firstSubTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        cardView.addSubview(firstDataLabel)
        firstDataLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(firstSubTitleLabel.snp.bottom)
        }
        
        cardView.addSubview(secondSubTitleLabel)
        secondSubTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(firstDataLabel.snp.bottom).offset(16)
        }
        
        cardView.addSubview(secondDataLabel)
        secondDataLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(secondSubTitleLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
        icon.addGestureRecognizer(tapGesture)
    }
    
    @objc private func iconTapped() {
        delegate?.didTapIcon(type: dataCardType)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setFirstSubtitle(_ label: String) {
        firstSubTitleLabel.text = label
    }
    
    func setFirstData (_ label: String) {
        firstDataLabel.text = label
    }
    
    func setSecondSubtitle(_ label: String) {
        secondSubTitleLabel.text = label
    }
    
    func setSecondData(_ label: String) {
        secondDataLabel.text = label
    }
}
