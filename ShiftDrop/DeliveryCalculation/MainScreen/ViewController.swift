//
//  ViewController.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 16.05.2025.
//

import SnapKit
import UIKit

class ViewController: UIViewController, PickButtonViewDelegate {

    private let dependencies: AppDependencies
    var deliveryInformation = DeliveryInformation()

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backgroundView: UIImageView = {
        let backgroundView = UIImageView(frame: .zero)
        backgroundView.image = UIImage(named: "delivery-calculation-background.pdf")
        backgroundView.contentMode = .scaleToFill
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    var workspaceView = UIView()
    var calculationMenu = UIView()
    var header = UILabel()
    var calculateButton = UIButton()
    var contentView = UIView()
    var packageSizeLabel = UILabel()
    
    var shippedFromView: PickButtonView = {
        let shippedFromView = PickButtonView(buttonType: .shippedFromCity)
        shippedFromView.setTitle("Город отправки")
        shippedFromView.setIcon(icon: UIImage(named: "marker"))
        shippedFromView.setValue("Москва")
        shippedFromView.setClickableWords(["Санкт-Петербург", "Новосибирск", "Томск"])
        return shippedFromView
    }()
    
    var shippedToView: PickButtonView = {
        let shippedToView = PickButtonView(buttonType: .shippedToCity)
        shippedToView.setTitle("Город назначения")
        shippedToView.setIcon(icon: UIImage(named: "pointer"))
        shippedToView.setValue("Санкт-Петербург")
        shippedToView.setClickableWords(["Новосибирск", "Томск", "Москва"])
        return shippedToView
    }()
    var packageSizeView: PickButtonView = {
        let packageSizeView = PickButtonView(buttonType: .packageSize)
        packageSizeView.setTitle("Размер посылки")
        packageSizeView.setIcon(icon: UIImage(named: "email.pdf"))
        packageSizeView.setValue("Конверт")
        return packageSizeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shippedFromView.delegate = self
        shippedToView.delegate = self
        packageSizeView.delegate = self
        
        view.insertSubview(backgroundView, at: 0)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let tabBar = self.tabBarController?.tabBar {
            tabBar.barTintColor = .white
            tabBar.backgroundColor = .white
        }
        
        self.view.addSubview(self.workspaceView)
        configureWorkspaceView()
        
        self.workspaceView.addSubview(self.calculationMenu)
        configureCalculationMenu()
        
        self.calculationMenu.addSubview(self.header)
        configureHeader()
        
        self.calculationMenu.addSubview(self.calculateButton)
        configureCalculateButton()
        
        self.calculationMenu.addSubview(self.contentView)
        configureContentView()
        
        self.contentView.addSubview(self.shippedFromView)
        configureShippedFromView()
        
        self.contentView.addSubview(self.shippedToView)
        configureShippedToView()
        
        self.contentView.addSubview(self.packageSizeView)
        configurePackageSizeView()
    }
    
    func configureWorkspaceView() {
        self.workspaceView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
    }
    
    func configureCalculationMenu() {
        self.calculationMenu.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(workspaceView)
            make.height.equalTo(500)
        }
        self.calculationMenu.backgroundColor = .white
        self.calculationMenu.layer.cornerRadius = 32
    }
    
    func configureHeader() {
        self.header.snp.makeConstraints { make in
            make.leading.trailing.equalTo(calculationMenu).inset(16)
            make.top.equalTo(calculationMenu).inset(32)
        }
        self.header.text = Localized.calcTitle
        self.header.textColor = UIColor(named: "TextPrimaryColor")
        self.header.textAlignment = .center
        self.header.font = .systemFont(ofSize: 28, weight: .bold)
    }
    
    func configureCalculateButton() {
        self.calculateButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(calculationMenu).inset(16)
            make.bottom.equalTo(calculationMenu).inset(32)
            make.height.equalTo(60)
        }
        calculateButton.addTarget(self, action: #selector(showShippingMethodScreen), for: .touchUpInside)
        self.calculateButton.setTitle(Localized.calcAction, for: .normal)
        self.calculateButton.setTitleColor(.white, for: .normal)
        self.calculateButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        self.calculateButton.backgroundColor = UIColor(named: "ButtonColor")
        self.calculateButton.layer.cornerRadius = 30
    }
    
    @objc func showShippingMethodScreen() {
        let shippingMethodViewController = ShippingMethodViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
        let navController = UINavigationController(rootViewController: shippingMethodViewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    func configureContentView() {
        self.contentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(calculationMenu).inset(16)
            make.top.equalTo(calculationMenu).inset(90)
            make.bottom.equalTo(calculationMenu).inset(120)
        }
    }
    
    func configureShippedFromView() {
        self.shippedFromView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
        }
    }
    
    func configureShippedToView() {
        self.shippedToView.snp.makeConstraints { make in
            make.top.equalTo(shippedFromView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configurePackageSizeView() {
        self.packageSizeView.snp.makeConstraints { make in
            make.top.equalTo(shippedToView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func didTapButton(type: ButtonType) {
        
        let shippedFromTableViewController = ShippedFromTableViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
        let shippedToTableViewController = ShippedToTableViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
        let packageSizeTableViewController = PackageSizeTableViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
        
        switch type {
            
        case .shippedFromCity:
            shippedFromTableViewController.onPointSelected = { [weak self] selectedPoint in
                self?.shippedFromView.setValue(selectedPoint.name)
                self?.deliveryInformation.senderPoint = selectedPoint
            }
            let navController = UINavigationController(rootViewController: shippedFromTableViewController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
            
        case .shippedToCity:
            shippedToTableViewController.onPointSelected = { [weak self] selectedPoint in
                self?.shippedToView.setValue(selectedPoint.name)
                self?.deliveryInformation.receiverPoint = selectedPoint
            }
            let navController = UINavigationController(rootViewController: shippedToTableViewController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
            
        case .packageSize:
            packageSizeTableViewController.onPackageSelected = { [weak self] selectedPackage in
                self?.packageSizeView.setValue(selectedPackage.name)
                self?.deliveryInformation.packageType = selectedPackage
            }
            let navController = UINavigationController(rootViewController: packageSizeTableViewController)
            navController.modalPresentationStyle = .formSheet
            present(navController, animated: true)
        }
    }
    
    func didSelectPoint(type: ButtonType, point: String) {
        switch type {
            
        case .shippedFromCity:
            shippedFromView.setValue(point)
            if (point == "Санкт-Петербург") {
                deliveryInformation.senderPoint = Point(id: "2", name: "Санкт-Петербург", latitude: 59.9343, longitude: 30.3351)
            }
            else if (point == "Новосибирск") {
                deliveryInformation.senderPoint = Point(id: "3", name: "Новосибирск", latitude: 55.0084, longitude: 82.9357)
            }
            else if (point == "Томск") {
                deliveryInformation.senderPoint = Point(id: "12", name: "Томск", latitude: 58.0104, longitude: 56.2294)
            }
        case .shippedToCity:
            shippedToView.setValue(point)
            if point == "Москва" {
                deliveryInformation.receiverPoint = Point(id: "1", name: "Москва", latitude: 55.7558, longitude: 37.6173)
            } else if point == "Новосибирск" {
                deliveryInformation.receiverPoint = Point(id: "3", name: "Новосибирск", latitude: 55.0084, longitude: 82.9357)
            } else if point == "Томск" {
                deliveryInformation.receiverPoint = Point(id: "12", name: "Томск", latitude: 58.0104, longitude: 56.2294)
            }
        case .packageSize: break
        }
    }
}

#Preview {
    ViewController(dependencies: AppDependencies.production())
}
