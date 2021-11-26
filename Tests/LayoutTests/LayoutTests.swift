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
        let constraints = view
            .layout
            .top()
            .constraints
        let expected = [view.topAnchor.constraint(equalTo: parent.topAnchor)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testTopCustom() {
        let constraints = view
            .layout
            .top(.lessThanOrEqual, to: otherView.bottomAnchor, constant: 2)
            .constraints
        let expected = [view.topAnchor.constraint(lessThanOrEqualTo: otherView.bottomAnchor, constant: 2)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testLeadingDefault() {
        let constraints = view
            .layout
            .leading()
            .constraints
        let expected = [view.leadingAnchor.constraint(equalTo: parent.leadingAnchor)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testLeadingCustom() {
        let constraints = view
            .layout
            .leading(.lessThanOrEqual, to: otherView.trailingAnchor, constant: 2)
            .constraints
        let expected = [view.leadingAnchor.constraint(lessThanOrEqualTo: otherView.trailingAnchor, constant: 2)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testBottomDefault() {
        let constraints = view
            .layout
            .bottom()
            .constraints
        let expected = [view.bottomAnchor.constraint(equalTo: parent.bottomAnchor)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testBottomCustom() {
        let constraints = view
            .layout
            .bottom(.lessThanOrEqual, to: otherView.topAnchor, constant: 2)
            .constraints
        let expected = [view.bottomAnchor.constraint(lessThanOrEqualTo: otherView.topAnchor, constant: 2)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testTrailingDefault() {
        let constraints = view
            .layout
            .trailing()
            .constraints
        let expected = [view.trailingAnchor.constraint(equalTo: parent.trailingAnchor)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testTrailingCustom() {
        let constraints = view
            .layout
            .trailing(.lessThanOrEqual, to: otherView.leadingAnchor, constant: 2)
            .constraints
        let expected = [view.trailingAnchor.constraint(lessThanOrEqualTo: otherView.leadingAnchor, constant: 2)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testAlignEdgesDefault() {
        let constraints = view
            .layout
            .alignEdges()
            .constraints
        let expected = [
            view.topAnchor.constraint(equalTo: parent.topAnchor),
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }
}
