# ShiftDrop — architecture

## Layers

| Path | Role |
|------|------|
| `App/` | `AppCoordinator` — root window + tab bar. |
| `Core/` | `AppDependencies`, `AppLogging`, `DeliveryAPIService` / `URLSessionDeliveryAPI`, `NetworkError`, `Localized`, `UIViewController+Alerts`. |
| `Application/` | `AppDelegate`, `SceneDelegate` → `AppCoordinator`. |
| `Models/` | Codable + `DeliveryInformation`, `Person`. |
| `DeliveryCalculation/`, `History/`, `Profile/` | UIKit features. |

## DI

`AppDependencies.production()` once at launch. `BaseViewController` and `ViewController` take `dependencies`; no service singletons.

## Networking

`API_BASE_URL` in `Info.plist` (fallback in `APIConfiguration`). Typed API via `DeliveryAPIService`; errors → `NetworkError`.

## Concurrency

Loads use `async/await` + `MainActor` for UI. Order submit awaits `placeOrder` before pushing success.

## Follow-ups

- `DeliveryFlowCoordinator` for the calculation modal stack.
- Optional DTO ↔ domain split if API grows.
- **Tests:** no XCTest target yet; highest value: JSON decode for responses, encoding for `DeliveryCalcRequest` / `DeliveryOrderRequest`, pure helpers (e.g. tariff copy).
- Full **String Catalog** when you externalize all copy.
