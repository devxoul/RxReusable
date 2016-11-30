//
//  RxReusable.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 29/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

private var disposeBagKey: String = "disposeBag"
private var willDisplaySubjectKey = "willDisplaySubject"
private var didEndDisplayingSubjectKey = "didEndDisplayingSubject"

public protocol RxReusableType: class, ReactiveCompatible {
  var disposeBag: DisposeBag { get }
}

extension RxReusableType where Self: UIView {
  private var _disposeBag: DisposeBag? {
    get { return self.associatedObject(for: &disposeBagKey) as? DisposeBag }
    set { self.setAssociatedObject(newValue, for: &disposeBagKey) }
  }

  /// A dispose bag which is disposed when the view or cell is preparing for being reused.
  public var disposeBag: DisposeBag {
    if let disposeBag = self._disposeBag {
      return disposeBag
    }
    let disposeBag = DisposeBag()
    self._disposeBag = disposeBag
    return disposeBag
  }

  /// Dispose the dispose bag manually.
  public func dispose() {
    self._disposeBag = nil
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
    let source = Observable.of(willDisplay, didEndDisplaying).merge().distinctUntilChanged()
    return ControlEvent(events: source)
  }
}
