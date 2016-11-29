RxReusable
==========

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/RxReusable.svg)](https://cocoapods.org/pods/RxReusable)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

RxReusable provides some APIs including `disposeBag` for managing life cycle of reusable cells and views.

## Why?

The dispose bag of reusable cells and views should be managed very carefully. If dispose bag doesn't dispose subscriptions properly, it will subscribe observables multiple times and cause memory leaks. In order to prevent from unwanted situation, the dispose bags should be disposed when:

* **the table view or collection view has just finished displaying cell**

    ```swift
    extension MyViewController: UITableViewDelegate {
      func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.disposeBag = nil
      }
    }
    ```


* **cell is preparing for being reused**

    ```swift
    class MyTableViewCell: UITableViewCell {
      override func prepareForReuse() {
        self.disposeBag = nil
      }
    }
    ```

It's too annoying to do these things everytime. This is why RxReusable is here. RxReusable provides a `disposeBag` property on reusable cells and views, and do the above things automatically.

## Features

* Automatically managed `disposeBag` on `UICollectionViewCell` and `UITableViewCell`
* `rx.willDisplay` and `rx.didEndDisplaying` on `UICollectionViewCell` and `UITableViewCell`

## Dependencies

- [RxSwift](https://github.com/ReactiveX/RxSwift) (>= 3.0)
- [RxCocoa](https://github.com/ReactiveX/RxSwift) (>= 3.0)

## Requirements

- Swift 3
- iOS 8+

## Installation

- **Using [CocoaPods](https://cocoapods.org)**:

    ```ruby
    pod 'RxReusable', '~> 0.1'
    ```

- **Using [Carthage](https://github.com/Carthage/Carthage)**:

    ```
    github "devxoul/RxReusable" ~> 0.1
    ```

## License

RxReusable is under MIT license.
