# ShiftDrop

UIKit: расчёт и оформление доставки.

## Требования

- Xcode 15+
- iOS 17.5+ (см. проект)
- SPM: [SnapKit](https://github.com/SnapKit/SnapKit)

## Сборка

Откройте `ShiftDrop.xcodeproj`, схема **ShiftDrop**, Run.

Тесты: **Product → Test** (схема **ShiftDrop**, симулятор iOS 17.5+).

Бэкенд: ключ **`API_BASE_URL`** в `ShiftDrop/Resources/Info.plist`.

Слои и сеть: [ARCHITECTURE.md](ARCHITECTURE.md).

Опционально: `brew install swiftlint && swiftlint`

## Подпись

Свой Team и при необходимости другой Bundle ID в Signing & Capabilities.
