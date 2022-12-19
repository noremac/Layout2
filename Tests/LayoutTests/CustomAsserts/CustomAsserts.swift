#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

import XCTest

@MainActor
private struct EquatableConstraintWrapper {
  let constraint: NSLayoutConstraint

  static func equal(_ lhs: Self, _ rhs: Self) -> Bool {
    let lc = lhs.constraint
    let rc = rhs.constraint
    return lc.firstItem === rc.firstItem
      && lc.firstAttribute == rc.firstAttribute
      && lc.relation == rc.relation
      && lc.secondItem === rc.secondItem
      && lc.secondAttribute == rc.secondAttribute
      && lc.constant == rc.constant
      && lc.multiplier == rc.multiplier
      && lc.priority == rc.priority
      && lc.isActive == rc.isActive
  }
}

@MainActor
func AssertConstraintsEqual(
  _ c1: some Collection<NSLayoutConstraint>,
  _ c2: some Collection<NSLayoutConstraint>,
  file: StaticString = #file,
  line: UInt = #line
) {
  func fail() {
    XCTFail("(\"\(c1)\") is not equal to (\"\(c2)\")", file: file, line: line)
  }
  guard c1.count == c2.count else {
    return fail()
  }

  let m1 = c1.map(EquatableConstraintWrapper.init(constraint:))
  let m2 = c2.map(EquatableConstraintWrapper.init(constraint:))

  let equal = m1.allSatisfy { c1 in
    for c2 in m2 {
      if EquatableConstraintWrapper.equal(c2, c2) {
        return true
      }
    }

    return false
  }

  guard equal else {
    return fail()
  }
//
//  if !m1.allSatisfy(m2.contains(_:)) {
//    fail()
//  }
}
