#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

import XCTest

@MainActor
private func constraintsEqual(_ lhs: NSLayoutConstraint, _ rhs: NSLayoutConstraint) -> Bool {
  lhs.firstItem === rhs.firstItem
    && lhs.firstAttribute == rhs.firstAttribute
    && lhs.relation == rhs.relation
    && lhs.secondItem === rhs.secondItem
    && lhs.secondAttribute == rhs.secondAttribute
    && lhs.constant == rhs.constant
    && lhs.multiplier == rhs.multiplier
    && lhs.priority == rhs.priority
    && lhs.isActive == rhs.isActive
}

@MainActor
func AssertConstraintsEqual(
  _ m1: some Collection<NSLayoutConstraint>,
  _ m2: some Collection<NSLayoutConstraint>,
  file: StaticString = #file,
  line: UInt = #line
) {
  func fail() {
    XCTFail("(\"\(m1)\") is not equal to (\"\(m2)\")", file: file, line: line)
  }
  guard m1.count == m2.count else {
    return fail()
  }

  let equal = m1.allSatisfy { c1 in
    for c2 in m2 {
      if constraintsEqual(c1, c2) {
        return true
      }
    }

    return false
  }

  guard equal else {
    return fail()
  }
}
