//
//  SecondViewController.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 17.05.2025.
//

import SnapKit
import UIKit

class SecondViewController: UIViewController {

    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = Localized.historyPlaceholder
        label.textColor = UIColor(named: "TextPrimaryColor")
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.accessibilityTraits.insert(.staticText)

        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(24)
            make.trailing.lessThanOrEqualToSuperview().inset(24)
        }
    }
}
