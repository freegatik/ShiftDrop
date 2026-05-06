import XCTest
@testable import ShiftDrop

@MainActor
final class TableListViewControllersTests: XCTestCase {

    private func embedInNavigation(_ root: UIViewController) -> UIWindow {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        window.rootViewController = UINavigationController(rootViewController: root)
        window.makeKeyAndVisible()
        return window
    }

    private func firstTableView(in vc: UIViewController) -> UITableView? {
        func search(_ view: UIView) -> UITableView? {
            if let table = view as? UITableView {
                return table
            }
            for sub in view.subviews {
                if let found = search(sub) {
                    return found
                }
            }
            return nil
        }
        return search(vc.view)
    }

    func testShippedFromTableLoadsPointRows() async throws {
        let api = MockDeliveryAPIService(
            fetchDeliveryPoints: {
                try await Task.sleep(nanoseconds: 0)
                return try MockDeliveryAPIFixtures.sampleTwoPoints()
            }
        )
        let deps = AppDependencies(api: api, logger: CapturingLogger())
        let vc = ShippedFromTableViewController(dependencies: deps, deliveryInformation: DeliveryInformation())
        _ = embedInNavigation(vc)
        vc.loadViewIfNeeded()
        try await Task.sleep(nanoseconds: 600_000_000)
        let table = try XCTUnwrap(firstTableView(in: vc))
        XCTAssertEqual(table.numberOfRows(inSection: 0), 2)
    }

    func testShippedToTableLoadsPointRows() async throws {
        let api = MockDeliveryAPIService(
            fetchDeliveryPoints: {
                try await Task.sleep(nanoseconds: 0)
                return try MockDeliveryAPIFixtures.sampleTwoPoints()
            }
        )
        let deps = AppDependencies(api: api, logger: CapturingLogger())
        let vc = ShippedToTableViewController(dependencies: deps, deliveryInformation: DeliveryInformation())
        _ = embedInNavigation(vc)
        vc.loadViewIfNeeded()
        try await Task.sleep(nanoseconds: 600_000_000)
        let table = try XCTUnwrap(firstTableView(in: vc))
        XCTAssertEqual(table.numberOfRows(inSection: 0), 2)
    }

    func testPackageSizeTableLoadsPackageRows() async throws {
        let api = MockDeliveryAPIService(
            fetchPackageTypes: {
                try await Task.sleep(nanoseconds: 0)
                return try MockDeliveryAPIFixtures.sampleTwoPackages()
            }
        )
        let deps = AppDependencies(api: api, logger: CapturingLogger())
        let vc = PackageSizeTableViewController(dependencies: deps, deliveryInformation: DeliveryInformation())
        _ = embedInNavigation(vc)
        vc.loadViewIfNeeded()
        try await Task.sleep(nanoseconds: 600_000_000)
        let table = try XCTUnwrap(firstTableView(in: vc))
        XCTAssertEqual(table.numberOfRows(inSection: 0), 2)
    }

    func testShippedFromFetchFailureLogsError() async throws {
        let log = CapturingLogger()
        let api = MockDeliveryAPIService(
            fetchDeliveryPoints: {
                throw NetworkError.noData
            }
        )
        let deps = AppDependencies(api: api, logger: log)
        let vc = ShippedFromTableViewController(dependencies: deps, deliveryInformation: DeliveryInformation())
        _ = embedInNavigation(vc)
        vc.loadViewIfNeeded()
        try await Task.sleep(nanoseconds: 600_000_000)
        XCTAssertTrue(log.snapshot().contains { $0.0 == .error && $0.1 == "Points" })
    }
}
