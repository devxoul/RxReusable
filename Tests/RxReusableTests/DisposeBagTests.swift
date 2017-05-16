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

fileprivate final class ReusableView: UIView, RxReusableType {
}

final class DisposeBagTests: XCTestCase {

  // MARK: CollectionViewCell

  func testPrepareForReuse_collectionViewCell() {
    let cell = UICollectionViewCell(frame: .zero)
    let oldDisposeBag = cell.disposeBag
    cell.prepareForReuse()
    let newDisposeBag = cell.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }

  func testPrepareForReuse_collectionViewCell_reusableSubview() {
    let cell = UICollectionViewCell(frame: .zero)
    let reusableView = ReusableView()
    cell.addSubview(reusableView)
    let oldDisposeBag = reusableView.disposeBag
    cell.prepareForReuse()
    let newDisposeBag = reusableView.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }

  func testPrepareForReuse_collectionViewCell_normalSubview_reusableSubview() {
    let cell = UICollectionViewCell(frame: .zero)
    let normalView = UIView()
    let reusableView = ReusableView()
    cell.addSubview(normalView)
    normalView.addSubview(reusableView)
    let oldDisposeBag = reusableView.disposeBag
    cell.prepareForReuse()
    let newDisposeBag = reusableView.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }


  // MARK: TableViewCell

  func testPrepareForReuse_tableViewCell() {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    let oldDisposeBag = cell.disposeBag
    cell.prepareForReuse()
    let newDisposeBag = cell.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }

  func testPrepareForReuse_tableViewCell_reusableSubview() {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    let reusableView = ReusableView()
    cell.addSubview(reusableView)
    let oldDisposeBag = reusableView.disposeBag
    cell.prepareForReuse()
    let newDisposeBag = reusableView.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }

  func testPrepareForReuse_tableViewCell_normalSubview_reusableSubview() {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    let normalView = UIView()
    let reusableView = ReusableView()
    cell.addSubview(normalView)
    normalView.addSubview(reusableView)
    let oldDisposeBag = reusableView.disposeBag
    cell.prepareForReuse()
    let newDisposeBag = reusableView.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }


  // MARK: CustomView

  func testPrepareForReuse_customView() {
    let view = ReusableView()
    let oldDisposeBag = view.disposeBag
    view.prepareForReuse()
    let newDisposeBag = view.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }

  func testPrepareForReuse_customView_reusableSubview() {
    let view = ReusableView()
    let reusableView = ReusableView()
    view.addSubview(reusableView)
    let oldDisposeBag = reusableView.disposeBag
    view.prepareForReuse()
    let newDisposeBag = reusableView.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }

  func testPrepareForReuse_customView_normalSubview_reusableSubview() {
    let view = ReusableView()
    let normalView = UIView()
    let reusableView = ReusableView()
    view.addSubview(normalView)
    normalView.addSubview(reusableView)
    let oldDisposeBag = reusableView.disposeBag
    view.prepareForReuse()
    let newDisposeBag = reusableView.disposeBag
    XCTAssert(oldDisposeBag !== newDisposeBag)
  }

}
