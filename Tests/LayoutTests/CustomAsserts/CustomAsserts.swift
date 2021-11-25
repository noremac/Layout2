#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

import XCTest

private struct EquatableConstraintWrapper: Equatable {
    let constraint: NSLayoutConstraint

    static func == (lhs: Self, rhs: Self) -> Bool {
        let lc = lhs.constraint
        let rc = rhs.constraint
        return lc.firstItem === rc.firstItem
        && lc.firstAttribute == rc.firstAttribute
        && lc.relation == rc.relation
        && lc.secondItem ===  rc.secondItem
        && lc.secondAttribute == rc.secondAttribute
        && lc.constant == rc.constant
        && lc.multiplier == rc.multiplier
        && lc.priority == rc.priority
        && lc.identifier == rc.identifier
        && lc.isActive == rc.isActive
    }
}

func AssertConstraintsEqual<C1, C2>(
    _ c1: C1,
    _ c2: C2,
    file: StaticString = #file,
    line: UInt = #line
) where C1: Collection, C1.Element == NSLayoutConstraint, C2: Collection, C2.Element == NSLayoutConstraint {
    func fail() {
        XCTFail("(\"\(c1)\") is not equal to (\"\(c2)\")", file: file, line: line)
    }
    guard c1.count == c2.count else {
        return fail()
    }

    let m1 = c1.map(EquatableConstraintWrapper.init(constraint:))
    let m2 = c2.map(EquatableConstraintWrapper.init(constraint:))

    let allMatch = m1.allSatisfy {
        m2.contains($0)
    }

    if !allMatch {
        return fail()
    }
}
