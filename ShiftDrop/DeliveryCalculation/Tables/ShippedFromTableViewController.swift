//
//  ShippedFromTableViewController.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 19.05.2025.
//

import UIKit
import SnapKit

class ShippedFromTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private var points: [Point] = []
    private let tableView = UITableView()
    
    var onPointSelected: ((Point) -> Void)?
    
    init(dependencies: AppDependencies, deliveryInformation: DeliveryInformation) {
        let headerView: HeaderView = {
            let headerView = HeaderView()
            headerView.setTitle("Откуда")
            return headerView
        }()
        
        super.init(dependencies: dependencies, iconImage: "cross.pdf", headerView: headerView, deliveryInformation: deliveryInformation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PointTableViewCell.self, forCellReuseIdentifier: "PointCell")
        
        view.addSubview(tableView)
        
        fetchCities()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview().inset(16)
        }
        tableView.separatorStyle = .none
    }
    
    override func leftBarButtonTapped() {
        dismiss(animated: true)
    }
    
    private func fetchCities() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let response = try await dependencies.api.fetchDeliveryPoints()
                await MainActor.run {
                    self.points = response.points
                    self.tableView.reloadData()
                }
            } catch {
                await MainActor.run {
                    self.dependencies.logger.error("Points", String(describing: error))
                    let message = (error as? NetworkError)?.userFacingMessage ?? Localized.errorGeneric
                    self.presentUserAlert(message: message)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointCell", for: indexPath)
        let point = points[indexPath.row]
        cell.textLabel?.text = point.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPoint = points[indexPath.row]
        onPointSelected?(selectedPoint)
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
}
