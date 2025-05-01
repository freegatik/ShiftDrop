//
//  DataCheckViewController.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 26.05.2025.
//

import UIKit
import SnapKit

class DataCheckViewController: BaseViewController, ButtonViewDelegate, DataCardViewDelegate {

    init(dependencies: AppDependencies, deliveryInformation: DeliveryInformation) {
        let headerView: HeaderView = {
            let headerView = HeaderView()
            headerView.setTitle("Проверка данных")
            return headerView
        }()
        
        super.init(dependencies: dependencies, iconImage: "cross.pdf", headerView: headerView, deliveryInformation: deliveryInformation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var receiverCardView: DataCardView = {
        let receiverCardView = DataCardView(dataCardType: .receiver)
        receiverCardView.setTitle("Получатель")
        receiverCardView.setFirstSubtitle("ФИО")
        receiverCardView.setSecondSubtitle("Телефон")
        return receiverCardView
    }()
    
    var senderCardView: DataCardView = {
        let senderCardView = DataCardView(dataCardType: .sender)
        senderCardView.setTitle("Отправитель")
        senderCardView.setFirstSubtitle("ФИО")
        senderCardView.setSecondSubtitle("Телефон")
        return senderCardView
    }()
    
    var senderPointCardView: DataCardView = {
        let senderPointCardView = DataCardView(dataCardType: .senderPoint)
        senderPointCardView.setTitle("Откуда забрать")
        senderPointCardView.setFirstSubtitle("Адрес")
        senderPointCardView.setSecondSubtitle("Заметка")
        return senderPointCardView
    }()
    
    var receiverPointCardView: DataCardView = {
        let receiverPointCardView = DataCardView(dataCardType: .receiverPoint)
        receiverPointCardView.setTitle("Куда доставить")
        receiverPointCardView.setFirstSubtitle("Адрес")
        receiverPointCardView.setSecondSubtitle("Заметка")
        return receiverPointCardView
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor(named: "TextPrimaryColor")
        return label
    }()
    
    var deliveryTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(named: "TextSecondaryColor")
        return label
    }()
    
    var deliveryTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(named: "TextSecondaryColor")
        return label
    }()
    
    var buttonView: ButtonView = {
        let buttonView = ButtonView()
        buttonView.setButtonTitle("Оформить")
        return buttonView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        buttonView.delegate = self
        receiverCardView.delegate = self
        senderCardView.delegate = self
        senderPointCardView.delegate = self
        receiverPointCardView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(receiverCardView)
        configureReceiverCardView()
        
        contentView.addSubview(senderCardView)
        configureSenderCardView()
        
        contentView.addSubview(senderPointCardView)
        configureSenderPointCardView()
        
        contentView.addSubview(receiverPointCardView)
        configureReceiverPointCardView()
        
        contentView.addSubview(priceLabel)
        configurePriceLabel()
        
        contentView.addSubview(deliveryTypeLabel)
        configureDeliveryTypeLabel()
        
        contentView.addSubview(deliveryTimeLabel)
        configureDeliveryTimeLabel()
        
        contentView.addSubview(buttonView)
        configureButtonView()
        
        setupScrollViewConstraints()
    }
    
    func setupScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView).priority(.low)
        }
    }
    
    func configureReceiverCardView() {
        receiverCardView.setFirstData("\(deliveryInformation.receiver?.name ?? "") \(deliveryInformation.receiver?.surname ?? "") \(deliveryInformation.receiver?.patronymic ?? "")")
        receiverCardView.setSecondData("\(deliveryInformation.receiver?.phoneNumber ?? "")")
        
        receiverCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(24)
        }
    }
    
    func configureSenderCardView() {
        senderCardView.setFirstData("\(deliveryInformation.sender?.name ?? "") \(deliveryInformation.sender?.surname ?? "") \(deliveryInformation.sender?.patronymic ?? "")")
        senderCardView.setSecondData("\(deliveryInformation.sender?.phoneNumber ?? "")")
        
        senderCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(receiverCardView.snp.bottom).offset(24)
        }
    }
    
    func configureSenderPointCardView() {
        senderPointCardView.setFirstData("г. \(deliveryInformation.senderPoint?.name ?? ""), ул. \(deliveryInformation.sender?.street ?? ""), д. \(deliveryInformation.sender?.house ?? ""), кв. \(deliveryInformation.sender?.roomNumber ?? "")")
        senderPointCardView.setSecondData("\(deliveryInformation.sender?.note ?? "")")
        
        senderPointCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(senderCardView.snp.bottom).offset(24)
        }
    }
    
    func configureReceiverPointCardView() {
        receiverPointCardView.setFirstData("г. \(deliveryInformation.receiverPoint?.name ?? ""), ул. \(deliveryInformation.receiver?.street ?? ""), д. \(deliveryInformation.receiver?.house ?? ""), кв. \(deliveryInformation.receiver?.roomNumber ?? "")")
        receiverPointCardView.setSecondData("\(deliveryInformation.receiver?.note ?? "")")
        
        receiverPointCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(senderPointCardView.snp.bottom).offset(24)
        }
    }
    
    func configurePriceLabel() {
        priceLabel.text = "Итого: \(deliveryInformation.deliveryPrice ?? 0)₽"
        
        priceLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(receiverPointCardView.snp.bottom).offset(24)
        }
    }
    
    func configureDeliveryTypeLabel() {
        if (deliveryInformation.deliveryType == "EXPRESS") {
            deliveryTypeLabel.text = "Тариф: Экспресс доставка до двери"
            
            deliveryTypeLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalTo(priceLabel.snp.bottom).offset(16)
            }
        }
        else {
            deliveryTypeLabel.text = "Тариф: Обычная доставка"
            
            deliveryTypeLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalTo(priceLabel.snp.bottom).offset(16)
            }
        }
    }
    
    func configureDeliveryTimeLabel() {
        deliveryTimeLabel.text = "Срок: \(daysString(deliveryInformation.deliveryTime ?? 0))"
        
        deliveryTimeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(deliveryTypeLabel.snp.bottom)
        }
    }
    
    func daysString(_ days: Int) -> String {
        let cases = [2, 0, 1, 1, 1, 2]
        let titles = ["рабочий день", "рабочих дня", "рабочих дней"]
        return "\(days) \(titles[(days % 100 > 4 && days % 100 < 20) ? 2 : cases[min(days % 10, 5)]])"
    }
    
    func configureButtonView() {
        buttonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(deliveryTimeLabel.snp.bottom).offset(36)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func didTapIcon(type: DataCardType){
        switch type {
        case .receiver:
            let receiverViewController = ReceiverReplicViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
            present(receiverViewController, animated: true)
            
        case .sender:
            let senderViewController = SenderReplicViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
            present(senderViewController, animated: true)
            
        case .senderPoint:
            let senderPointViewController = WhereToPickUpReplicViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
            present(senderPointViewController, animated: true)
            
        case .receiverPoint:
            let receiverPointViewController = WhereToDeliverReplicViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
            present(receiverPointViewController, animated: true)
        }
    }
    
    func didTapButton(in view: ButtonView) {
        Task { await submitOrder() }
    }

    @MainActor
    private func submitOrder() async {
        guard let deliveryOrderRequest = makeOrderRequest() else {
            presentUserAlert(message: Localized.orderValidationFailed)
            return
        }
        do {
            let response = try await dependencies.api.placeOrder(deliveryOrderRequest)
            dependencies.logger.info(
                "Order",
                "placed status=\(response.order.status) cancellable=\(response.order.cancellable)"
            )
            let successViewController = SuccessViewController(dependencies: dependencies, deliveryInformation: deliveryInformation)
            navigationController?.pushViewController(successViewController, animated: true)
        } catch {
            dependencies.logger.error("Order", String(describing: error))
            let message = (error as? NetworkError)?.userFacingMessage ?? Localized.errorGeneric
            presentUserAlert(message: message)
        }
    }

    private func makeOrderRequest() -> DeliveryOrderRequest? {
        let senderPoint = SenderPointRequest(
            id: deliveryInformation.senderPoint?.id ?? "",
            name: deliveryInformation.senderPoint?.name ?? "",
            latitude: deliveryInformation.senderPoint?.latitude ?? 0,
            longitude: deliveryInformation.senderPoint?.longitude ?? 0
        )

        guard let senderStreet = deliveryInformation.sender?.street,
              let senderHouse = deliveryInformation.sender?.house,
              let senderApartment = deliveryInformation.sender?.roomNumber,
              let senderComment = deliveryInformation.sender?.note
        else { return nil }
        let senderAddress = SenderAddressRequest(
            street: senderStreet,
            house: senderHouse,
            apartment: senderApartment,
            comment: senderComment
        )

        guard let senderFirstName = deliveryInformation.sender?.name,
              let senderLastName = deliveryInformation.sender?.surname,
              let senderMiddleName = deliveryInformation.sender?.patronymic,
              let senderPhone = deliveryInformation.sender?.phoneNumber
        else { return nil }
        let sender = Sender(
            firstname: senderFirstName,
            lastname: senderLastName,
            middlename: senderMiddleName,
            phone: senderPhone
        )

        let receiverPoint = ReceiverPointRequest(
            id: deliveryInformation.receiverPoint?.id ?? "",
            name: deliveryInformation.receiverPoint?.name ?? "",
            latitude: deliveryInformation.receiverPoint?.latitude ?? 0,
            longitude: deliveryInformation.receiverPoint?.longitude ?? 0
        )

        guard let receiverStreet = deliveryInformation.receiver?.street,
              let receiverHouse = deliveryInformation.receiver?.house,
              let receiverApartment = deliveryInformation.receiver?.roomNumber,
              let receiverComment = deliveryInformation.receiver?.note
        else { return nil }
        let receiverAddress = ReceiverAddressRequest(
            street: receiverStreet,
            house: receiverHouse,
            apartment: receiverApartment,
            comment: receiverComment
        )

        guard let receiverFirstName = deliveryInformation.receiver?.name,
              let receiverLastName = deliveryInformation.receiver?.surname,
              let receiverMiddleName = deliveryInformation.receiver?.patronymic,
              let receiverPhone = deliveryInformation.receiver?.phoneNumber
        else { return nil }
        let receiver = Receiver(
            firstname: receiverFirstName,
            lastname: receiverLastName,
            middlename: receiverMiddleName,
            phone: receiverPhone
        )

        guard let id = deliveryInformation.id,
              let days = deliveryInformation.deliveryTime,
              let price = deliveryInformation.deliveryPrice,
              let name = deliveryInformation.name,
              let type = deliveryInformation.deliveryType
        else { return nil }

        let option = OptionsRequest(id: id, days: days, price: price, name: name, type: type)

        return DeliveryOrderRequest(
            senderPoint: senderPoint,
            senderAddress: senderAddress,
            sender: sender,
            receiverPoint: receiverPoint,
            receiverAddress: receiverAddress,
            receiver: receiver,
            payer: deliveryInformation.whoPay ?? "",
            option: option
        )
    }
    
    override func leftBarButtonTapped() {
        dismiss(animated: true)
    }
}
