//
//  RxReusable.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 29/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import RxSwift

private var disposeBagKey: String = "disposeBag"

/// A protocol which defines `disposeBag`.
public protocol RxReusableType: class {
  var disposeBag: DisposeBag { get }
}

extension RxReusableType where Self: NSObject {

  private var _disposeBag: DisposeBag? {
    get { return self.associatedObject(for: &disposeBagKey) as? DisposeBag }
    set { self.setAssociatedObject(newValue, for: &disposeBagKey) }
  }

  /// A dispose bag which is disposed when the cell gets out of the screen or prepares for being
  /// reused.
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
