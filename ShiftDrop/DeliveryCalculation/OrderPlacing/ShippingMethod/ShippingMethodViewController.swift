//
//  ShippingMethodViewController.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 18.05.2025.
//

import UIKit
import SnapKit

class ShippingMethodViewController: BaseViewController, DeliveryTypeViewDelegate {

    init(dependencies: AppDependencies, deliveryInformation: DeliveryInformation) {
        let headerView: HeaderView = {
            let headerView = HeaderView()
            headerView.setTitle("Способ отправки")
            return headerView
        }()
        
        super.init(dependencies: dependencies, iconImage: "cross.pdf", headerView: headerView, deliveryInformation: deliveryInformation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var expressDeliveryView: DeliveryTypeView = {
        let expressDeliveryView = DeliveryTypeView(deliveryType: .express)
        expressDeliveryView.setTitle("Экспресс доставка до двери")
        expressDeliveryView.setIcon(icon: UIImage(named: "express-delivery.pdf"))
        return expressDeliveryView
    }()
    
    var usualDeliveryView: DeliveryTypeView = {
        let expressDeliveryView = DeliveryTypeView(deliveryType: .usual)
        expressDeliveryView.setTitle("Обычная доставка")
        expressDeliveryView.setIcon(icon: UIImage(named: "usual-delivery.pdf"))
        return expressDeliveryView
    }()
    
    var deliveryExpressPrice: Int?
    var deliveryUsualPrice: Int?
    var deliveryExpressTime: Int?
    var deliveryUsualTime: Int?
    var deliveryExpressID: String?
    var deliveryUsualID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        createDeliveryRequest()
        
        expressDeliveryView.delegate = self
        usualDeliveryView.delegate = self
        
        self.view.addSubview(expressDeliveryView)
        configureExpressDeliveryView()
        
        self.view.addSubview(usualDeliveryView)
        configureUsualDeliveryView()
    }
    
    func configureExpressDeliveryView() {
        self.expressDeliveryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(36)
        }
    }
    
    func configureUsualDeliveryView() {
        self.usualDeliveryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(expressDeliveryView.snp.bottom).offset(24)
        }
    }
    
    func createDeliveryRequest() {
        guard let senderPoint = deliveryInformation.senderPoint else { return }
        guard let receiverPoint = deliveryInformation.receiverPoint else { return }
        guard let packageType = deliveryInformation.packageType else { return }

        let senderPointRequest = PointRequest(latitude: senderPoint.latitude, longitude: senderPoint.longitude)
        let receiverPointRequest = PointRequest(latitude: receiverPoint.latitude, longitude: receiverPoint.longitude)
        let packageTypeRequest = PackageRequest(length: packageType.length, width: packageType.width, weight: packageType.weight, height: packageType.height)

        let deliveryCalcRequest = DeliveryCalcRequest(package: packageTypeRequest, senderPoint: senderPointRequest, receiverPoint: receiverPointRequest)

        Task { [weak self] in
            guard let self else { return }
            do {
                let response = try await dependencies.api.calculateDelivery(deliveryCalcRequest)
                await MainActor.run {
                    self.applyCalcResponse(response)
                }
            } catch {
                await MainActor.run {
                    self.dependencies.logger.error("Calc", String(describing: error))
                    let message = (error as? NetworkError)?.userFacingMessage ?? Localized.errorGeneric
                    self.presentUserAlert(message: message)
                }
            }
        }
    }

    private func applyCalcResponse(_ response: DeliveryCalcResponse) {
        guard response.options.count >= 2 else {
            presentUserAlert(message: Localized.errorGeneric)
            return
        }
        let usualPrice = response.options[0].price
        usualDeliveryView.setPrice("\(usualPrice) ₽")
        deliveryUsualPrice = usualPrice
        deliveryUsualID = response.options[0].id

        let usualTime = response.options[0].days
        usualDeliveryView.setDeliveryTime(daysString(usualTime))
        deliveryUsualTime = usualTime

        let expressPrice = response.options[1].price
        expressDeliveryView.setPrice("\(expressPrice) ₽")
        deliveryExpressPrice = expressPrice
        deliveryExpressID = response.options[1].id

        let expressTime = response.options[1].days
        expressDeliveryView.setDeliveryTime(daysString(expressTime))
        deliveryExpressTime = expressTime
    }
    
    func daysString(_ days: Int) -> String {
        let cases = [2, 0, 1, 1, 1, 2]
        let titles = ["рабочий день", "рабочих дня", "рабочих дней"]
        return "\(days) \(titles[(days % 100 > 4 && days % 100 < 20) ? 2 : cases[min(days % 10, 5)]])"
    }
    
    func didTapButton(type: DeliveryType) {
        switch type {
        case .express:
            deliveryInformation.deliveryType = "EXPRESS"
            deliveryInformation.name = "эксперсс доставка"
            deliveryInformation.deliveryPrice = deliveryExpressPrice
            deliveryInformation.deliveryTime = deliveryExpressTime
            deliveryInformation.id = deliveryExpressID
        case .usual:
            deliveryInformation.deliveryType = "DEFAULT"
            deliveryInformation.name = "стандартная доставка"
            deliveryInformation.deliveryPrice = deliveryUsualPrice
            deliveryInformation.deliveryTime = deliveryUsualTime
            deliveryInformation.id = deliveryUsualID
        }
        let receiverViewController = ReceiverViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
        navigationController?.pushViewController(receiverViewController, animated: true)
    }
    
    override func leftBarButtonTapped() {
        self.dismiss(animated: true)
    }
}
