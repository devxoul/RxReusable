//
//  UITableView+RxReusable.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 29/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxCocoa

#if os(iOS)
private var didSubscribeKey = "didSubscribe"

extension UITableView {

  open override static func initialize() {
    guard self === UITableView.self else { return }
    self._rxreusable_swizzle(
      #selector(UITableView.didMoveToWindow),
      #selector(UITableView._rxreusable_didMoveToWindow)
    )
  }

  func _rxreusable_didMoveToWindow() {
    self._rxreusable_didMoveToWindow()
    guard self.associatedObject(for: &didSubscribeKey) as? Bool != true else { return }
    self.setAssociatedObject(true, for: &didSubscribeKey)

    _ = self.rx.willDisplayCell
      .takeUntil(self.rx.deallocated)
      .subscribe(onNext: { cell, indexPath in
        cell.traverseSubviews { view in
          (view as? UITableViewCell)?.rx.willDisplaySubject.onNext(indexPath)
        }
      })
    _ = self.rx.didEndDisplayingCell
      .takeUntil(self.rx.deallocated)
      .subscribe(onNext: { cell, indexPath in
        cell.traverseSubviews { view in
          (view as? UITableViewCell)?.rx.didEndDisplayingSubject.onNext(indexPath)
        }
      })
  }

}
#endif
