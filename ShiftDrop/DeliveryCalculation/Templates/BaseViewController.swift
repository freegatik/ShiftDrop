//
//  BaseViewController.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 12.05.2025.
//

import UIKit

class BaseViewController: UIViewController {

    let dependencies: AppDependencies
    let iconImage: String
    let headerView: HeaderView
    var deliveryInformation: DeliveryInformation

    init(
        dependencies: AppDependencies,
        iconImage: String,
        headerView: HeaderView,
        deliveryInformation: DeliveryInformation
    ) {
        self.dependencies = dependencies
        self.iconImage = iconImage
        self.headerView = headerView
        self.deliveryInformation = deliveryInformation
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        
        let leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: iconImage),
            style: .plain,
            target: self,
            action: #selector(leftBarButtonTapped)
        )
        leftBarButtonItem.tintColor = UIColor(named: "IndicatorLightColor")
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationItem.titleView = headerView
    }
    
    @objc func leftBarButtonTapped() {}
}
