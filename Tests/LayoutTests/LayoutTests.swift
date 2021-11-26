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

    func testAlignEdgesCustom() {
        let constraints = view
            .layout
            .alignEdges(to: otherView, insets: .init(top: 1, leading: 2, bottom: 3, trailing: 4))
            .constraints
        let expected = [
            view.topAnchor.constraint(equalTo: otherView.topAnchor, constant: 1),
            view.leadingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: 2),
            view.bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: -3),
            view.trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: -4),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testAlignEdgesIndividual() {
        do {
            let constraints = view
                .layout
                .alignEdges(.top)
                .constraints
            let expected = [view.topAnchor.constraint(equalTo: parent.topAnchor)]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .alignEdges(.leading)
                .constraints
            let expected = [view.leadingAnchor.constraint(equalTo: parent.leadingAnchor)]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .alignEdges(.bottom)
                .constraints
            let expected = [view.bottomAnchor.constraint(equalTo: parent.bottomAnchor)]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .alignEdges(.trailing)
                .constraints
            let expected = [view.trailingAnchor.constraint(equalTo: parent.trailingAnchor)]
            AssertConstraintsEqual(constraints, expected)
        }
    }

    func testContainEdgesDefault() {
        let constraints = view
            .layout
            .containEdges(.all)
            .constraints
        let expected = [
            view.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor),
            view.leadingAnchor.constraint(greaterThanOrEqualTo: parent.leadingAnchor),
            view.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor),
            view.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testContainEdgesCustom() {
        let constraints = view
            .layout
            .containEdges(.all, within: otherView, insets: .init(top: 1, leading: 2, bottom: 3, trailing: 4))
            .constraints
        let expected = [
            view.topAnchor.constraint(greaterThanOrEqualTo: otherView.topAnchor, constant: 1),
            view.leadingAnchor.constraint(greaterThanOrEqualTo: otherView.leadingAnchor, constant: 2),
            view.bottomAnchor.constraint(lessThanOrEqualTo: otherView.bottomAnchor, constant: -3),
            view.trailingAnchor.constraint(lessThanOrEqualTo: otherView.trailingAnchor, constant: -4),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testContainEdgesIndividual() {
        do {
            let constraints = view
                .layout
                .containEdges(.top)
                .constraints
            let expected = [view.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor)]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .containEdges(.leading)
                .constraints
            let expected = [view.leadingAnchor.constraint(greaterThanOrEqualTo: parent.leadingAnchor)]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .containEdges(.bottom)
                .constraints
            let expected = [view.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor)]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .containEdges(.trailing)
                .constraints
            let expected = [view.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor)]
            AssertConstraintsEqual(constraints, expected)
        }
    }

    func testCenterXDefault() {
        let constraints = view
            .layout
            .centerX()
            .constraints
        let expected = [view.centerXAnchor.constraint(equalTo: parent.centerXAnchor)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testCenterXCustom() {
        let constraints = view
            .layout
            .centerX(.lessThanOrEqual, to: otherView.leadingAnchor, constant: 2)
            .constraints
        let expected = [view.centerXAnchor.constraint(lessThanOrEqualTo: otherView.leadingAnchor, constant: 2)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testCenterYDefault() {
        let constraints = view
            .layout
            .centerY()
            .constraints
        let expected = [view.centerYAnchor.constraint(equalTo: parent.centerYAnchor)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testCenterYCustom() {
        let constraints = view
            .layout
            .centerY(.lessThanOrEqual, to: otherView.topAnchor, constant: 2)
            .constraints
        let expected = [view.centerYAnchor.constraint(lessThanOrEqualTo: otherView.topAnchor, constant: 2)]
        AssertConstraintsEqual(constraints, expected)
    }

    func testCenterDefault() {
        let constraints = view
            .layout
            .center()
            .constraints
        let expected = [
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testCenterCustom() {
        let constraints = view
            .layout
            .center(within: otherView)
            .constraints
        let expected = [
            view.centerXAnchor.constraint(equalTo: otherView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: otherView.centerYAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }
}
