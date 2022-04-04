import Layout
import XCTest

#if canImport(AppKit)
import AppKit
typealias _View = NSView
#elseif canImport(UIKit)
import UIKit
typealias _View = UIView
#else
#error("Unsupported platform")
#endif

final class LayoutTests: XCTestCase {
    lazy var parent = _View()

    lazy var view: _View = {
        let view = _View()
        parent.addSubview(view)
        return view
    }()

    lazy var otherView: _View = {
        let view = _View()
        parent.addSubview(view)
        return view
    }()

    func testPriority() {
        let constraints = view
            .layout
            .bottom(priority: .defaultHigh)
            .constraints
        let bottom = view.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        bottom.priority = .defaultHigh
        let expected = [
            bottom,
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testIdentifier() {
        let constraints = view
            .layout
            .bottom(identifier: "1")
            .constraints
        XCTAssertEqual(constraints.map(\.identifier), ["1"])
    }

    func testActivate() {
        let constraints = view
            .layout
            .top()
            .activate()
        let expected = [
            view.topAnchor.constraint(equalTo: parent.topAnchor),
        ]
        NSLayoutConstraint.activate(expected)
        AssertConstraintsEqual(constraints, expected)
    }

    func testTopDefault() {
        let constraints = view
            .layout
            .top()
            .constraints
        let expected = [
            view.topAnchor.constraint(equalTo: parent.topAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testTopCustom() {
        let constraints = view
            .layout
            .top(.lessThanOrEqual, to: otherView.bottomAnchor, constant: 2)
            .constraints
        let expected = [
            view.topAnchor.constraint(lessThanOrEqualTo: otherView.bottomAnchor, constant: 2),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testLeadingDefault() {
        let constraints = view
            .layout
            .leading()
            .constraints
        let expected = [
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testLeadingCustom() {
        let constraints = view
            .layout
            .leading(.lessThanOrEqual, to: otherView.trailingAnchor, constant: 2)
            .constraints
        let expected = [
            view.leadingAnchor.constraint(lessThanOrEqualTo: otherView.trailingAnchor, constant: 2),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testBottomDefault() {
        let constraints = view
            .layout
            .bottom()
            .constraints
        let expected = [
            view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testBottomCustom() {
        let constraints = view
            .layout
            .bottom(.lessThanOrEqual, to: otherView.topAnchor, constant: 2)
            .constraints
        let expected = [
            view.bottomAnchor.constraint(lessThanOrEqualTo: otherView.topAnchor, constant: 2),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testTrailingDefault() {
        let constraints = view
            .layout
            .trailing()
            .constraints
        let expected = [
            view.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testTrailingCustom() {
        let constraints = view
            .layout
            .trailing(.lessThanOrEqual, to: otherView.leadingAnchor, constant: 2)
            .constraints
        let expected = [
            view.trailingAnchor.constraint(lessThanOrEqualTo: otherView.leadingAnchor, constant: 2),
        ]
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
            let expected = [
                view.topAnchor.constraint(equalTo: parent.topAnchor),
            ]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .alignEdges(.leading)
                .constraints
            let expected = [
                view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            ]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .alignEdges(.bottom)
                .constraints
            let expected = [
                view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            ]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .alignEdges(.trailing)
                .constraints
            let expected = [
                view.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            ]
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
            let expected = [
                view.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor),
            ]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .containEdges(.leading)
                .constraints
            let expected = [
                view.leadingAnchor.constraint(greaterThanOrEqualTo: parent.leadingAnchor),
            ]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .containEdges(.bottom)
                .constraints
            let expected = [
                view.bottomAnchor.constraint(lessThanOrEqualTo: parent.bottomAnchor),
            ]
            AssertConstraintsEqual(constraints, expected)
        }

        do {
            let constraints = view
                .layout
                .containEdges(.trailing)
                .constraints
            let expected = [
                view.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor),
            ]
            AssertConstraintsEqual(constraints, expected)
        }
    }

    func testCenterXDefault() {
        let constraints = view
            .layout
            .centerX()
            .constraints
        let expected = [
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testCenterXCustom() {
        let constraints = view
            .layout
            .centerX(.lessThanOrEqual, to: otherView.leadingAnchor, constant: 2)
            .constraints
        let expected = [
            view.centerXAnchor.constraint(lessThanOrEqualTo: otherView.leadingAnchor, constant: 2),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testCenterYDefault() {
        let constraints = view
            .layout
            .centerY()
            .constraints
        let expected = [
            view.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testCenterYCustom() {
        let constraints = view
            .layout
            .centerY(.lessThanOrEqual, to: otherView.topAnchor, constant: 2)
            .constraints
        let expected = [
            view.centerYAnchor.constraint(lessThanOrEqualTo: otherView.topAnchor, constant: 2),
        ]
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

    func testMatchWidthDefault() {
        let constraints = view
            .layout
            .matchWidth()
            .constraints
        let expected = [
            view.widthAnchor.constraint(equalTo: parent.widthAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testMatchWidthCustom() {
        let constraints = view
            .layout
            .matchWidth(.greaterThanOrEqual, to: otherView.heightAnchor, multiplier: 2, constant: 3)
            .constraints
        let expected = [
            view.widthAnchor.constraint(greaterThanOrEqualTo: otherView.heightAnchor, multiplier: 2, constant: 3),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testMatchHeightDefault() {
        let constraints = view
            .layout
            .matchHeight()
            .constraints
        let expected = [
            view.heightAnchor.constraint(equalTo: parent.heightAnchor),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testMatchHeightCustom() {
        let constraints = view
            .layout
            .matchHeight(.lessThanOrEqual, to: otherView.widthAnchor, multiplier: 2, constant: 3)
            .constraints
        let expected = [
            view.heightAnchor.constraint(lessThanOrEqualTo: otherView.widthAnchor, multiplier: 2, constant: 3),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testWidthRelation() {
        let constraints = view
            .layout
            .width(.greaterThanOrEqual, to: 1)
            .constraints
        let expected = [
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 1),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testWidth() {
        let constraints = view
            .layout
            .width(1)
            .constraints
        let expected = [
            view.widthAnchor.constraint(equalToConstant: 1),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testHeightRelation() {
        let constraints = view
            .layout
            .height(.lessThanOrEqual, to: 1)
            .constraints
        let expected = [
            view.heightAnchor.constraint(lessThanOrEqualToConstant: 1),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testHeight() {
        let constraints = view
            .layout
            .height(1)
            .constraints
        let expected = [
            view.heightAnchor.constraint(equalToConstant: 1),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testSizeRelation() {
        let constraints = view
            .layout
            .size(.lessThanOrEqual, to: CGSize(width: 1, height: 2))
            .constraints
        let expected = [
            view.widthAnchor.constraint(lessThanOrEqualToConstant: 1),
            view.heightAnchor.constraint(lessThanOrEqualToConstant: 2),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testSize() {
        let constraints = view
            .layout
            .size(CGSize(width: 1, height: 2))
            .constraints
        let expected = [
            view.widthAnchor.constraint(equalToConstant: 1),
            view.heightAnchor.constraint(equalToConstant: 2),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testMatchSizeDefault() {
        let constraints = view
            .layout
            .matchSize()
            .constraints
        let expected = [
            view.widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 1, constant: 0),
            view.heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: 1, constant: 0),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testMatchSizeCustom() {
        let constraints = view
            .layout
            .matchSize(.lessThanOrEqual, to: otherView, multiplier: 2)
            .constraints
        let expected = [
            view.widthAnchor.constraint(lessThanOrEqualTo: otherView.widthAnchor, multiplier: 2, constant: 0),
            view.heightAnchor.constraint(lessThanOrEqualTo: otherView.heightAnchor, multiplier: 2, constant: 0),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testAspectRatioSize() {
        let constraints = view
            .layout
            .aspectRatio(CGSize(width: 3, height: 2))
            .constraints
        let expected = [
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3 / 2, constant: 0),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testAspectRatio() {
        let constraints = view
            .layout
            .aspectRatio(3 / 2)
            .constraints
        let expected = [
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3 / 2, constant: 0),
        ]
        AssertConstraintsEqual(constraints, expected)
    }

    func testPerformance() {
        var count = 0
        measure {
            for _ in 0..<10000 {
                count += view
                    .layout
                    .height(10)
                    .aspectRatio(CGSize(width: 3, height: 2))
                    .alignEdges()
                    .constraints
                    .count
            }
        }
        XCTAssertEqual(count, 600_000)
    }
}
