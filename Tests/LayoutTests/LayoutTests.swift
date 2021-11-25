import Layout
import XCTest

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

final class LayoutTests: XCTestCase {
    #if canImport(UIKit)
    lazy var parent = UIView()

    lazy var view: UIView = {
        let view = UIView()
        parent.addSubview(view)
        return view
    }()

    lazy var otherView: UIView = {
        let view = UIView()
        parent.addSubview(view)
        return view
    }()
    #elseif canImport(AppKit)
    lazy var parent = NSView()

    lazy var view: NSView = {
        let view = NSView()
        parent.addSubview(view)
        return view
    }()

    lazy var otherView: NSView = {
        let view = NSView()
        parent.addSubview(view)
        return view
    }()
    #endif

    func testTopDefault() {
        let constraints = view.layout.top().constraints
        let expected = [view.topAnchor.constraint(equalTo: parent.topAnchor)]
        AssertConstraintsEqual(constraints, expected)
    }
}
