//
//  UICollectionView+RxReusable.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 29/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

#if os(iOS)
public typealias CollectionViewWillDisplayCellEvent = (
  cell: UICollectionViewCell,
  indexPath: IndexPath
)
public typealias CollectionViewDidEndDisplayingCellEvent = (
  cell: UICollectionViewCell,
  indexPath: IndexPath
)

extension UICollectionView {

  public static let initializer: Void = {
    swizzle()
  }()

  static func swizzle() {
    guard self === UICollectionView.self else { return }
    UICollectionView._rxreusable_swizzle(
      #selector(UICollectionView.init(frame:collectionViewLayout:)),
      #selector(UICollectionView._rxreusable_init(frame:collectionViewLayout:))
    )
  }

  @objc func _rxreusable_init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) -> UICollectionView {
    let instance = self._rxreusable_init(frame: frame, collectionViewLayout: collectionViewLayout)
    _ = instance.rx.willDisplayCell
      .takeUntil(instance.rx.deallocated)
      .subscribe(onNext: { cell, indexPath in
        cell.traverseSubviews { view in
          (view as? UICollectionViewCell)?.rx.willDisplaySubject.onNext(indexPath)
        }
      })
    _ = instance.rx.didEndDisplayingCell
      .takeUntil(instance.rx.deallocated)
      .subscribe(onNext: { cell, indexPath in
        cell.traverseSubviews { view in
          (view as? UICollectionViewCell)?.rx.didEndDisplayingSubject.onNext(indexPath)
        }
      })
    return instance
  }

}

extension Reactive where Base: UICollectionView {

  var willDisplayCell: ControlEvent<CollectionViewWillDisplayCellEvent> {
    let selector = #selector(UICollectionViewDelegate.collectionView(_:willDisplay:forItemAt:))
    let source: Observable<CollectionViewWillDisplayCellEvent> = self.delegate.methodInvoked(selector)
      .map { args in
        return (
          try castOrThrow(UICollectionViewCell.self, args[1]),
          try castOrThrow(IndexPath.self, args[2])
        )
      }
    return ControlEvent(events: source)
  }

  var didEndDisplayingCell: ControlEvent<CollectionViewDidEndDisplayingCellEvent> {
    let selector = #selector(UICollectionViewDelegate.collectionView(_:didEndDisplaying:forItemAt:))
    let source: Observable<CollectionViewDidEndDisplayingCellEvent> = self.delegate.methodInvoked(selector)
      .map { args in
        return (
          try castOrThrow(UICollectionViewCell.self, args[1]),
          try castOrThrow(IndexPath.self, args[2])
        )
      }
    return ControlEvent(events: source)
  }

}
#endif

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
  guard let returnValue = object as? T else {
    throw RxCocoaError.castingError(object: object, targetType: resultType)
  }
  return returnValue
}
