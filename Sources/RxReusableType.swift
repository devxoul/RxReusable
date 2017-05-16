//
//  RxReusable.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 29/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

private var disposeBagKey: String = "disposeBag"
private var willDisplaySubjectKey = "willDisplaySubject"
private var didEndDisplayingSubjectKey = "didEndDisplayingSubject"

public protocol RxReusableType: class {
  var disposeBag: DisposeBag { get }
  func dispose()
  func dispose(propagate: Bool)
}

extension RxReusableType where Self: UIView {
  private var _disposeBag: DisposeBag? {
    get { return self.associatedObject(for: &disposeBagKey) as? DisposeBag }
    set { self.setAssociatedObject(newValue, for: &disposeBagKey) }
  }

  /// A dispose bag which is disposed when the view or cell is preparing for being reused.
  public var disposeBag: DisposeBag {
    get {
      if let disposeBag = self._disposeBag {
        return disposeBag
      }
      let disposeBag = DisposeBag()
      self._disposeBag = disposeBag
      return disposeBag
    }
    set {
      self._disposeBag = newValue
    }
  }

  public func prepareForReuse() {
    self.dispose()
  }

  public func dispose() {
    self.dispose(propagate: true)
  }

  /// Dispose the dispose bag manually.
  public func dispose(propagate: Bool) {
    if !propagate {
      self._disposeBag = nil
      return
    }
    self.traverseSubviews { view in
      (view as? RxReusableType)?.dispose(propagate: false)
    }
  }
}

extension Reactive where Base: RxReusableType, Base: UIView {
  internal var willDisplaySubject: PublishSubject<IndexPath> {
    if let subject = self.base.associatedObject(for: &willDisplaySubjectKey) as? PublishSubject<IndexPath> {
      return subject
    }
    let subject = PublishSubject<IndexPath>()
    self.base.setAssociatedObject(subject, for: &willDisplaySubjectKey)
    return subject
  }

  internal var didEndDisplayingSubject: PublishSubject<IndexPath> {
    if let subject = self.base.associatedObject(for: &didEndDisplayingSubjectKey) as? PublishSubject<IndexPath> {
      return subject
    }
    let subject = PublishSubject<IndexPath>()
    self.base.setAssociatedObject(subject, for: &didEndDisplayingSubjectKey)
    return subject
  }

  /// The reactive wrapper for the cell or view is currently displaying or not.
  public var isDisplaying: ControlEvent<Bool> {
    let willDisplay = self.willDisplaySubject.asObservable().map { _ in true }
    let didEndDisplaying = self.didEndDisplayingSubject.asObservable().map { _ in false }
    let source = Observable.of(willDisplay, didEndDisplaying).merge()
      .distinctUntilChanged()
      .startWith(false)
    return ControlEvent(events: source)
  }
}
