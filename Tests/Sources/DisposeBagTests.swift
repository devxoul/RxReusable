//
//  DisposeBagTests.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 13/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest

import RxCocoa
import RxSwift

import RxReusable

fileprivate final class MyView: UIView, RxReusableType {
}

final class DisposeBagTests: XCTestCase {

  func testCollectionViewCell_prepareForReuse() {
    let cell = UICollectionViewCell(frame: .zero)
    let oldDisposeBag = cell.disposeBag
    cell.prepareForReuse()
    let newDisposeBag = cell.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }

  func testTableViewCell_prepareForReuse() {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    let oldDisposeBag = cell.disposeBag
    cell.prepareForReuse()
    let newDisposeBag = cell.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }

  func testCustomView_prepareForReuse() {
    let view = MyView()
    let oldDisposeBag = view.disposeBag
    view.prepareForReuse()
    let newDisposeBag = view.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }

}
