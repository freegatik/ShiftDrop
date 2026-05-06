import XCTest
@testable import ShiftDrop

final class AppCoreLayerTests: XCTestCase {

    func testLogLevelOrdering() {
        XCTAssertLessThan(LogLevel.debug, LogLevel.info)
        XCTAssertLessThan(LogLevel.info, LogLevel.warning)
        XCTAssertLessThan(LogLevel.warning, LogLevel.error)
    }

    func testCapturingLoggerReceivesExtensionMethods() {
        let logger = CapturingLogger()
        logger.debug("c", "d")
        logger.info("c", "i")
        logger.warning("c", "w")
        logger.error("c", "e")
        let snap = logger.snapshot()
        XCTAssertEqual(snap.count, 4)
        XCTAssertEqual(snap.map(\.0), [.debug, .info, .warning, .error])
    }

    func testConsoleLoggerSmoke() {
        let logger = ConsoleLogger(subsystem: "shift.ShiftDropTests", minLevel: .error)
        logger.error("test", "smoke")
    }

    func testNetworkErrorUserFacingMessages() {
        let cases: [NetworkError] = [
            .invalidURL,
            .transport(CocoaError(.fileNoSuchFile)),
            .noData,
            .httpStatus(code: 418),
            .decodingFailed,
            .encodingFailed,
        ]
        for err in cases {
            XCTAssertFalse(err.userFacingMessage.isEmpty, "\(err)")
            XCTAssertEqual(err.errorDescription, err.userFacingMessage)
        }
    }

    func testLocalizedStringsNonEmpty() {
        XCTAssertFalse(Localized.tabCalculation.isEmpty)
        XCTAssertFalse(Localized.tabHistory.isEmpty)
        XCTAssertFalse(Localized.tabProfile.isEmpty)
        XCTAssertFalse(Localized.calcTitle.isEmpty)
        XCTAssertFalse(Localized.calcAction.isEmpty)
        XCTAssertFalse(Localized.historyPlaceholder.isEmpty)
        XCTAssertFalse(Localized.profilePlaceholder.isEmpty)
        XCTAssertFalse(Localized.errorGeneric.isEmpty)
        XCTAssertFalse(Localized.errorOk.isEmpty)
        XCTAssertFalse(Localized.orderValidationFailed.isEmpty)
    }

    func testAppDependenciesProduction() {
        let deps = AppDependencies.production()
        XCTAssertTrue(deps.api is URLSessionDeliveryAPI)
        XCTAssertTrue(deps.logger is ConsoleLogger)
    }

    func testAppDependenciesUsesInjectedMocks() {
        let api = MockDeliveryAPIService()
        let log = CapturingLogger()
        let deps = AppDependencies(api: api, logger: log)
        XCTAssertTrue(deps.api is MockDeliveryAPIService)
    }

    func testAPIConfigurationBaseURLFormat() {
        let base = APIConfiguration.baseURLString
        XCTAssertTrue(base.hasSuffix("/"), "base URL should end with slash, got: \(base)")
        XCTAssertFalse(base.isEmpty)
        XCTAssertNotNil(URL(string: base))
    }

    func testDeliveryInformationDefaults() {
        var info = DeliveryInformation()
        XCTAssertNotNil(info.senderPoint)
        XCTAssertNotNil(info.receiverPoint)
        XCTAssertNotNil(info.packageType)
        info.senderPoint = nil
        XCTAssertNil(info.senderPoint)
    }

    func testPersonMutation() {
        var p = Person(
            name: "A",
            surname: "B",
            patronymic: "C",
            phoneNumber: "1",
            street: "S",
            house: "1",
            roomNumber: "2",
            note: "n"
        )
        p.name = "Z"
        XCTAssertEqual(p.name, "Z")
    }

    func testDeliveryOrderRequestEncodeShape() throws {
        let order = DeliveryOrderRequest(
            senderPoint: SenderPointRequest(id: "1", name: "M", latitude: 1, longitude: 2),
            senderAddress: SenderAddressRequest(street: "s", house: "h", apartment: "a", comment: "c"),
            sender: Sender(firstname: "A", lastname: "B", middlename: "C", phone: "0"),
            receiverPoint: ReceiverPointRequest(id: "2", name: "R", latitude: 3, longitude: 4),
            receiverAddress: ReceiverAddressRequest(street: "rs", house: "rh", apartment: nil, comment: nil),
            receiver: Receiver(firstname: "X", lastname: "Y", middlename: nil, phone: "9"),
            payer: "SENDER",
            option: OptionsRequest(id: "opt", days: 2, price: 10, name: "N", type: "DEFAULT")
        )
        let data = try JSONEncoder().encode(order)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        XCTAssertNotNil(json["senderPoint"])
        XCTAssertNotNil(json["receiverPoint"])
        XCTAssertNotNil(json["option"])
        XCTAssertEqual(json["payer"] as? String, "SENDER")
    }
}
