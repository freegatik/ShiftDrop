//
//  PackageSizeTableViewController.swift
//  ShiftDrop
//
//  Created by Anton Solovev on 21.05.2025.
//

import UIKit
import SnapKit

class PackageSizeTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private var packageTypes: [Package] = []
    private let tableView = UITableView()
    
    var onPackageSelected: ((Package) -> Void)?
    
    init(dependencies: AppDependencies, deliveryInformation: DeliveryInformation) {
        let headerView: HeaderView = {
            let headerView = HeaderView()
            headerView.setTitle("Размер посылки")
            return headerView
        }()
        
        super.init(dependencies: dependencies, iconImage: "chevron-down.pdf", headerView: headerView, deliveryInformation: deliveryInformation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PackageTableViewCell.self, forCellReuseIdentifier: "PackageCell")
        view.addSubview(tableView)
        
        fetchPackages()
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
    
    private func fetchPackages() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let response = try await dependencies.api.fetchPackageTypes()
                await MainActor.run {
                    self.packageTypes = response.packages
                    self.tableView.reloadData()
                }
            } catch {
                await MainActor.run {
                    self.dependencies.logger.error("Packages", String(describing: error))
                    let message = (error as? NetworkError)?.userFacingMessage ?? Localized.errorGeneric
                    self.presentUserAlert(message: message)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageCell", for: indexPath)
        let package = packageTypes[indexPath.row]
        cell.textLabel?.text = "\(package.name), \(package.length)х\(package.width)x\(package.height) см"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPackage = packageTypes[indexPath.row]
        onPackageSelected?(selectedPackage)
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
}
