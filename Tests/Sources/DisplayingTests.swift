//
//  DisplayingTests.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 13/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import XCTest

import RxCocoa
import RxExpect
import RxSwift
import RxTest

@testable import RxReusable

fileprivate final class CollectionViewDelegate: NSObject, UICollectionViewDelegate {}
fileprivate final class TableViewDelegate: NSObject, UITableViewDelegate {}

final class DisplayingTests: XCTestCase {

  var disposeBag: DisposeBag!

  var collectionView: UICollectionView!
  var collectionViewCell: UICollectionViewCell!

  var tableView: UITableView!
  var tableViewCell: UITableViewCell!

  override func setUp() {
    super.setUp()
    self.disposeBag = DisposeBag()

    self.collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    self.collectionView.rx.setDelegate(CollectionViewDelegate()).addDisposableTo(self.disposeBag)
    self.collectionViewCell = UICollectionViewCell(frame: .zero)

    self.tableView = UITableView(frame: .zero)
    self.tableView.rx.setDelegate(TableViewDelegate()).addDisposableTo(self.disposeBag)
    self.tableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
  }

  override func tearDown() {
    self.disposeBag = nil
    super.tearDown()
  }

  func testCollectionView_isDisplaying() {
    RxExpect { test in
      self.invokeCollectionViewWillDisplay(test, 100)
      self.invokeCollectionViewDidEndDisplaying(test, 200)
      test
        .assert(self.collectionViewCell.rx.isDisplaying.asObservable())
        .filterNext()
        .equal([false, true, false])
    }
  }

  func testCollectionView_whileDisplaying() {
    RxExpect { test in
      let subject = PublishSubject<String>()
      let source = subject.whileDisplaying(self.collectionViewCell)
      test.input(subject, [
        next(100, "A"),
        next(200, "B"),
        next(300, "C"),
        next(400, "D"),
        next(500, "E"),
        next(600, "F"),
      ])
      self.invokeCollectionViewWillDisplay(test, 250)
      self.invokeCollectionViewDidEndDisplaying(test, 450)
      test
        .assert(source)
        .filterNext()
        .equal(["C", "D"])
    }
  }

  func testTableView_isDisplaying() {
    RxExpect { test in
      self.invokeTableViewWillDisplay(test, 100)
      self.invokeTableViewDidEndDisplaying(test, 200)
      test
        .assert(self.tableViewCell.rx.isDisplaying.asObservable())
        .filterNext()
        .equal([false, true, false])
    }
  }

  func testTableView_whileDisplaying() {
    RxExpect { test in
      let subject = PublishSubject<String>()
      let source = subject.whileDisplaying(self.tableViewCell)
      test.input(subject, [
        next(100, "A"),
        next(200, "B"),
        next(300, "C"),
        next(400, "D"),
        next(500, "E"),
        next(600, "F"),
      ])
      self.invokeTableViewWillDisplay(test, 250)
      self.invokeTableViewDidEndDisplaying(test, 450)
      test
        .assert(source)
        .filterNext()
        .equal(["C", "D"])
    }
  }


  // MARK: UICollectionView Utils

  private func invokeCollectionViewWillDisplay(_ test: RxExpectation, _ time: TestTime) {
    let subject = PublishSubject<Void>()
    subject
      .subscribe(onNext: {
        let indexPath = IndexPath(item: 0, section: 0)
        let delegate = self.collectionView.rx.delegate as! UICollectionViewDelegate
        delegate.collectionView!(
          self.collectionView,
          willDisplay: self.collectionViewCell,
          forItemAt: indexPath
        )
      })
      .addDisposableTo(self.disposeBag)
    test.input(subject, [next(time, Void())])
  }

  private func invokeCollectionViewDidEndDisplaying(_ test: RxExpectation, _ time: TestTime) {
    let subject = PublishSubject<Void>()
    subject
      .subscribe(onNext: {
        let indexPath = IndexPath(item: 0, section: 0)
        let delegate = self.collectionView.rx.delegate as! UICollectionViewDelegate
        delegate.collectionView!(
          self.collectionView,
          didEndDisplaying: self.collectionViewCell,
          forItemAt: indexPath
        )
      })
      .addDisposableTo(self.disposeBag)
    test.input(subject, [next(time, Void())])
  }


  // MARK: UITableView Utils

  private func invokeTableViewWillDisplay(_ test: RxExpectation, _ time: TestTime) {
    let subject = PublishSubject<Void>()
    subject
      .subscribe(onNext: {
        let indexPath = IndexPath(item: 0, section: 0)
        let delegate = self.tableView.rx.delegate as! UITableViewDelegate
        delegate.tableView!(
          self.tableView,
          willDisplay: self.tableViewCell,
          forRowAt: indexPath
        )
      })
      .addDisposableTo(self.disposeBag)
    test.input(subject, [next(time, Void())])
  }

  private func invokeTableViewDidEndDisplaying(_ test: RxExpectation, _ time: TestTime) {
    let subject = PublishSubject<Void>()
    subject
      .subscribe(onNext: {
        let indexPath = IndexPath(item: 0, section: 0)
        let delegate = self.tableView.rx.delegate as! UITableViewDelegate
        delegate.tableView!(
          self.tableView,
          didEndDisplaying: self.tableViewCell,
          forRowAt: indexPath
        )
      })
      .addDisposableTo(self.disposeBag)
    test.input(subject, [next(time, Void())])
  }

}
