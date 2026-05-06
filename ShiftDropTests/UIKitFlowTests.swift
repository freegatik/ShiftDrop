import XCTest
@testable import ShiftDrop

@MainActor
final class UIKitFlowTests: XCTestCase {

    private func embedInKeyWindow(_ root: UIViewController) -> UIWindow {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        window.rootViewController = root
        window.makeKeyAndVisible()
        return window
    }

    private func waitUntil(timeout: TimeInterval, _ condition: @escaping () -> Bool) async -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if condition() { return true }
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        return condition()
    }

    func testViewControllerCalculatePresentsShippingNav() throws {
        let deps = AppDependencies(api: MockDeliveryAPIService(), logger: CapturingLogger())
        let vc = ViewController(dependencies: deps)
        _ = embedInKeyWindow(vc)
        vc.loadViewIfNeeded()
        vc.beginAppearanceTransition(true, animated: false)
        vc.endAppearanceTransition()
        vc.showShippingMethodScreen()
        let exp = expectation(description: "present")
        DispatchQueue.main.async { exp.fulfill() }
        wait(for: [exp], timeout: 1.5)
        let nav = try XCTUnwrap(vc.presentedViewController as? UINavigationController)
        XCTAssertTrue(nav.topViewController is ShippingMethodViewController)
    }

    func testViewControllerDidSelectPointUpdatesDeliveryInformation() {
        let deps = AppDependencies(api: MockDeliveryAPIService(), logger: CapturingLogger())
        let vc = ViewController(dependencies: deps)
        vc.loadViewIfNeeded()
        vc.didSelectPoint(type: .shippedFromCity, point: "Томск")
        XCTAssertEqual(vc.deliveryInformation.senderPoint?.id, "12")
        XCTAssertEqual(vc.deliveryInformation.senderPoint?.name, "Томск")
        vc.didSelectPoint(type: .shippedToCity, point: "Москва")
        XCTAssertEqual(vc.deliveryInformation.receiverPoint?.id, "1")
    }

    func testSecondViewControllerShowsHistoryPlaceholder() {
        let deps = AppDependencies(api: MockDeliveryAPIService(), logger: CapturingLogger())
        let vc = SecondViewController(dependencies: deps)
        vc.loadViewIfNeeded()
        let label = vc.view.subviews.compactMap { $0 as? UILabel }.first
        XCTAssertEqual(label?.text, Localized.historyPlaceholder)
    }

    func testThirdViewControllerShowsProfilePlaceholder() {
        let deps = AppDependencies(api: MockDeliveryAPIService(), logger: CapturingLogger())
        let vc = ThirdViewController(dependencies: deps)
        vc.loadViewIfNeeded()
        let label = vc.view.subviews.compactMap { $0 as? UILabel }.first
        XCTAssertEqual(label?.text, Localized.profilePlaceholder)
    }

    func testShippingMethodDaysStringPluralization() {
        let deps = AppDependencies(api: MockDeliveryAPIService(), logger: CapturingLogger())
        let vc = ShippingMethodViewController(dependencies: deps, deliveryInformation: DeliveryInformation())
        XCTAssertEqual(vc.daysString(1), "1 рабочий день")
        XCTAssertEqual(vc.daysString(2), "2 рабочих дня")
        XCTAssertEqual(vc.daysString(5), "5 рабочих дней")
        XCTAssertEqual(vc.daysString(11), "11 рабочих дней")
    }

    func testShippingMethodCalcAppliesPrices() async {
        let deps = AppDependencies(api: MockDeliveryAPIService(), logger: CapturingLogger())
        let vc = ShippingMethodViewController(dependencies: deps, deliveryInformation: DeliveryInformation())
        let nav = UINavigationController(rootViewController: vc)
        _ = embedInKeyWindow(nav)
        vc.loadViewIfNeeded()
        let ok = await waitUntil(timeout: 3) { vc.deliveryExpressPrice != nil && vc.deliveryUsualPrice != nil }
        XCTAssertTrue(ok, "calc Task should populate prices")
        XCTAssertEqual(vc.deliveryUsualPrice, 100)
        XCTAssertEqual(vc.deliveryExpressPrice, 500)
    }

    func testShippingMethodCalcFailureLogsError() async throws {
        let api = MockDeliveryAPIService(
            calculateDelivery: { _ in
                throw NetworkError.noData
            }
        )
        let log = CapturingLogger()
        let deps = AppDependencies(api: api, logger: log)
        let vc = ShippingMethodViewController(dependencies: deps, deliveryInformation: DeliveryInformation())
        let nav = UINavigationController(rootViewController: vc)
        _ = embedInKeyWindow(nav)
        vc.loadViewIfNeeded()
        try await Task.sleep(nanoseconds: 900_000_000)
        let calcErrors = log.snapshot().filter { $0.0 == .error && $0.1 == "Calc" }
        XCTAssertEqual(calcErrors.count, 1)
        XCTAssertFalse(calcErrors[0].2.isEmpty)
    }

    func testShippingMethodAfterCalcExpressTapPushesReceiver() async {
        let deps = AppDependencies(api: MockDeliveryAPIService(), logger: CapturingLogger())
        let vc = ShippingMethodViewController(dependencies: deps, deliveryInformation: DeliveryInformation())
        let nav = UINavigationController(rootViewController: vc)
        _ = embedInKeyWindow(nav)
        vc.loadViewIfNeeded()
        let calcDone = await waitUntil(timeout: 3) { vc.deliveryExpressPrice != nil }
        XCTAssertTrue(calcDone)
        vc.didTapButton(type: .express)
        XCTAssertTrue(nav.topViewController is ReceiverViewController)
        XCTAssertEqual(vc.deliveryInformation.deliveryType, "EXPRESS")
        XCTAssertEqual(vc.deliveryInformation.deliveryPrice, 500)
    }
}
