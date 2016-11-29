//
//  RxReusableCell.swift
//  Cell
//
//  Created by Suyeol Jeon on 29/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

private var willDisplaySubjectKey = "willDisplaySubject"
private var didEndDisplayingSubjectKey = "didEndDisplayingSubject"

public protocol RxReusableCell: class, RxReusableType {
}

extension Reactive where Base: RxReusableCell, Base: NSObject {

  var willDisplaySubject: PublishSubject<IndexPath> {
    if let subject = self.base.associatedObject(for: &willDisplaySubjectKey) as? PublishSubject<IndexPath> {
      return subject
    }
    let subject = PublishSubject<IndexPath>()
    self.base.setAssociatedObject(subject, for: &willDisplaySubjectKey)
    return subject
  }
  public var willDisplay: Observable<IndexPath> {
    return self.willDisplaySubject.asObservable()
  }

  var didEndDisplayingSubject: PublishSubject<IndexPath> {
    if let subject = self.base.associatedObject(for: &didEndDisplayingSubjectKey) as? PublishSubject<IndexPath> {
      return subject
    }
    let subject = PublishSubject<IndexPath>()
    self.base.setAssociatedObject(subject, for: &didEndDisplayingSubjectKey)
    return subject
  }
  public var didEndDisplaying: Observable<IndexPath> {
    return self.didEndDisplayingSubject.asObservable()
  }

}
