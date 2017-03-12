//
//  Observable+RxReusable.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 30/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import RxSwift

extension ObservableType {

  /// Makes the sequence emit items only when the `reusable` is currently displaying or not.
  ///
  /// - parameter reusable: The reusable cell or view.
  /// - parameter value: Whether the reusable is displaying or not.
  public func whileDisplaying<R>(_ reusable: R, _ value: Bool = true) -> Observable<E> where R: RxReusableType, R: ReactiveCompatible, R: UIView {
    return self
      .withLatestFrom(reusable.rx.isDisplaying) { ($0, $1) }
      .flatMap { element, isDisplaying in
        return (isDisplaying == value) ? Observable.just(element) : Observable.empty()
      }
  }

}
