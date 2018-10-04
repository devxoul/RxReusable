//
//  ViewController.swift
//  Example
//
//  Created by Suyeol Jeon on 30/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReusableKit
import RxSwift

final class ViewController: UIViewController {

  // MARK: Constants

  fileprivate struct Reusable {
    static let timerCell = ReusableCell<TimerCell>()
  }


  // MARK: Properties

  fileprivate let timers = (0..<2).map { _ in
    Observable<Int>.interval(1, scheduler: MainScheduler.instance)
  }
  fileprivate let disposeBag = DisposeBag()


  // MARK: UI

  fileprivate let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.register(Reusable.timerCell)
  }


  // MARK: View life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.automaticallyAdjustsScrollViewInsets = false
    self.view.backgroundColor = .white
    self.tableView.layer.borderWidth = 1 / UIScreen.main.scale
    self.tableView.layer.borderColor = UIColor.gray.cgColor
    self.tableView.rx.setDataSource(self).disposed(by: self.disposeBag)
    self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
    self.view.addSubview(self.tableView)
  }


  // MARK: Layout

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.tableView.frame.origin.x = 50
    self.tableView.frame.size.width = self.view.bounds.width - 100
    self.tableView.frame.size.height = 100
    self.tableView.center.y = self.view.bounds.height / 2
  }

}

extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.timers.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(Reusable.timerCell, for: indexPath)
    cell.configure(timer: self.timers[indexPath.row], indexPath: indexPath)
    return cell
  }

}

extension ViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return TimerCell.height(width: tableView.bounds.width)
  }

}
