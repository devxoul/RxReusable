//
//  NSObject+RxReusable
//  RxReusable
//
//  Created by Suyeol Jeon on 29/11/2016.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import Foundation

extension NSObject {
  static func _rxreusable_swizzle(_ originalSelector: Selector, _ swizzledSelector: Selector) {
    let originalMethod = class_getInstanceMethod(self, originalSelector)
    let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
    let originalType = method_getTypeEncoding(originalMethod)
    let swizzledType = method_getTypeEncoding(swizzledMethod)
    let didAdd = class_addMethod(self, originalSelector, swizzledMethod, swizzledType)
    if didAdd {
      class_replaceMethod(self, swizzledSelector, originalMethod, originalType)
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod)
    }
  }
}

extension NSObject {
  func associatedObject(for key: UnsafeRawPointer) -> Any? {
    return objc_getAssociatedObject(self, key)
  }

  func setAssociatedObject(_ object: Any?, for key: UnsafeRawPointer) {
    objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
}
