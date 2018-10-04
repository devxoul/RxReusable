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

    UICollectionViewCell.initializer
    UICollectionView.initializer
    self.collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    self.collectionView.rx.setDelegate(CollectionViewDelegate()).disposed(by: self.disposeBag)
    self.collectionViewCell = UICollectionViewCell(frame: .zero)

    UITableViewCell.initializer
    UITableView.initializer
    self.tableView = UITableView(frame: .zero)
    self.tableView.rx.setDelegate(TableViewDelegate()).disposed(by: self.disposeBag)
    self.tableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
  }

  override func tearDown() {
    self.disposeBag = nil
    super.tearDown()
  }

  func testIsDisplaying_collectionViewCell() {
    let test = RxExpect()
    self.invokeCollectionViewWillDisplay(test, 100)
    self.invokeCollectionViewDidEndDisplaying(test, 200)
    test.assert(self.collectionViewCell.rx.isDisplaying) {
      XCTAssertEqual($0.elements, [false, true, false])
    }
  }

  func testIsDisplaying_collectionViewCell_subcell() {
    let test = RxExpect()
    let subcell = UICollectionViewCell(frame: .zero)
    self.collectionViewCell.addSubview(subcell)
    self.invokeCollectionViewWillDisplay(test, 100)
    self.invokeCollectionViewDidEndDisplaying(test, 200)
    test.assert(subcell.rx.isDisplaying) {
      XCTAssertEqual($0.elements, [false, true, false])
    }
  }

  func testWhileDisplaying_collectionViewCell() {
    let test = RxExpect()
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
    test.assert(source) {
      XCTAssertEqual($0.elements, ["C", "D"])
    }
  }

  func testWhileDisplaying_collectionViewCell_subcell() {
    let test = RxExpect()
    let subcell = UICollectionViewCell(frame: .zero)
    self.collectionViewCell.addSubview(subcell)
    let subject = PublishSubject<String>()
    let source = subject.whileDisplaying(subcell)
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
    test.assert(source) {
      XCTAssertEqual($0.elements, ["C", "D"])
    }
  }


  // MARK: TableView

  func testIsDisplaying_tableViewCell() {
    let test = RxExpect()
    self.invokeTableViewWillDisplay(test, 100)
    self.invokeTableViewDidEndDisplaying(test, 200)
    test.assert(self.tableViewCell.rx.isDisplaying) {
      XCTAssertEqual($0.elements, [false, true, false])
    }
  }

  func testIsDisplaying_tableViewCell_subcell() {
    let subcell = UITableViewCell()
    self.tableViewCell.addSubview(subcell)
    let test = RxExpect()
    self.invokeTableViewWillDisplay(test, 100)
    self.invokeTableViewDidEndDisplaying(test, 200)
    test.assert(subcell.rx.isDisplaying) {
      XCTAssertEqual($0.elements, [false, true, false])
    }
  }

  func testWhileDisplaying_tableViewCell() {
    let test = RxExpect()
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
    test.assert(source) {
      XCTAssertEqual($0.elements, ["C", "D"])
    }
  }

  func testWhileDisplaying_tableViewCell_subcell() {
    let subcell = UITableViewCell()
    self.tableViewCell.addSubview(subcell)
    let test = RxExpect()
    let subject = PublishSubject<String>()
    let source = subject.whileDisplaying(subcell)
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
    test.assert(source) {
      XCTAssertEqual($0.elements, ["C", "D"])
    }
  }


  // MARK: UICollectionView Utils

  private func invokeCollectionViewWillDisplay(_ test: RxExpect, _ time: TestTime) {
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
      .disposed(by: self.disposeBag)
    test.input(subject, [next(time, Void())])
  }

  private func invokeCollectionViewDidEndDisplaying(_ test: RxExpect, _ time: TestTime) {
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
      .disposed(by: self.disposeBag)
    test.input(subject, [next(time, Void())])
  }


  // MARK: UITableView Utils

  private func invokeTableViewWillDisplay(_ test: RxExpect, _ time: TestTime) {
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
      .disposed(by: self.disposeBag)
    test.input(subject, [next(time, Void())])
  }

  private func invokeTableViewDidEndDisplaying(_ test: RxExpect, _ time: TestTime) {
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
      .disposed(by: self.disposeBag)
    test.input(subject, [next(time, Void())])
  }

}
