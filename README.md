RxReusable
==========

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/RxReusable.svg)](https://cocoapods.org/pods/RxReusable)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

RxReusable provides some APIs for managing life cycle of reusable cells and views.

## APIs

> ⚠️ In order to use these features properly, you should set delegate by using `rx.setDelegate(_:)`.
>
> **UITableView**
>
> ```diff
> - tableView.delegate = self
> + tableView.rx.setDelegate(self)
> ```
>
> **UICollectionView**
>
> ```diff
> - collectionView.delegate = self
> + collectionView.rx.setDelegate(self)
> ```

* **`var disposeBag: DisposeBag`**

    `UITableViewCell` and `UICollectionView` now has their own `disposeBag` as a property. The dispose bag is automatically disposed on `prepareForReuse()`.

    ```swift
    let cell: UITableViewCell = ...
    observable
      .subscribe()
      .addDisposableTo(cell.disposeBag)
    ```

* **`var isDisplaying: ControlEvent<Bool>`**

    The reactive wrapper for the cell or view is currently displaying or not. This will emit `true` when the `tableView(_:willDisplay:forRowAt:)` or `collectionView(_:willDisplay:forItemAt:)` is executed and `false` when the `tableView(_:didEndDisplaying:forRowAt:)` or `collectionView(_:didEndDisplaying:forItemAt:)` is executed.

* **`func whileDisplaying(_:_:)`**

    This operator makes the observable emit items only when the cell or view is currently displaying or not.

    ```swift
    let cell: UITableViewCell = ...
    observable.whileDisplaying(cell, true)  // emit items when the cell is visible
    observable.whileDisplaying(cell, false) // emit items when the cell is not visible
    ```

## Dependencies

- [RxSwift](https://github.com/ReactiveX/RxSwift) (>= 3.0)
- [RxCocoa](https://github.com/ReactiveX/RxSwift) (>= 3.0)

## Requirements

- Swift 3
- iOS 8+

## Installation

- **Using [CocoaPods](https://cocoapods.org)**:

    ```ruby
    pod 'RxReusable', '~> 0.2'
    ```

- **Using [Carthage](https://github.com/Carthage/Carthage)**:

    ```
    github "devxoul/RxReusable" ~> 0.2
    ```

## License

RxReusable is under MIT license.
