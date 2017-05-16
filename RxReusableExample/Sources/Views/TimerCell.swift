//
//  BannerScrollerCell.swift
//  RxReusable
//
//  Created by Suyeol Jeon on 30/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxSwift

final class TimerCell: UITableViewCell {

  // MARK: Configuring

  func configure(timer: Observable<Int>, indexPath: IndexPath) {
    self.selectionStyle = .none
    self.backgroundColor = .gray
    guard let textLabel = self.textLabel else { return }

    self.backgroundColor = (indexPath.row == 0) ? .red : .lightGray
    let emoji = (indexPath.row == 0) ? "🍎" : "💀"
    self.rx.isDisplaying
        .subscribe(onNext: { isDisplaying in
          print("\(emoji) became \(isDisplaying ? "visible" : "invisible")")
        })
        .addDisposableTo(self.disposeBag)

    if indexPath.row == 0 {
      textLabel.text = "I emit \(emoji) while visible"
      timer
        .whileDisplaying(self)
        .subscribe(onNext: { _ in print("\(emoji) I am currently visible") })
        .addDisposableTo(self.disposeBag)
    } else {
      textLabel.text = "I emit \(emoji) while not visible"
      timer
        .whileDisplaying(self, false)
        .subscribe(onNext: { _ in print("\(emoji) I am currently not visible") })
        .addDisposableTo(self.disposeBag)
    }
  }


  // MARK: Size

  class func height(width: CGFloat) -> CGFloat {
    return 100
  }

}
