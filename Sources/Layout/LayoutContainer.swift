import UIKit

public protocol LayoutContainer {
    var layout: Layout { get }

    var parentContainer: LayoutContainer { get }

    var leadingAnchor: NSLayoutXAxisAnchor { get }

    var trailingAnchor: NSLayoutXAxisAnchor { get }

    var leftAnchor: NSLayoutXAxisAnchor { get }

    var rightAnchor: NSLayoutXAxisAnchor { get }

    var topAnchor: NSLayoutYAxisAnchor { get }

    var bottomAnchor: NSLayoutYAxisAnchor { get }

    var widthAnchor: NSLayoutDimension { get }

    var heightAnchor: NSLayoutDimension { get }

    var centerXAnchor: NSLayoutXAxisAnchor { get }

    var centerYAnchor: NSLayoutYAxisAnchor { get }

    var firstBaselineAnchor: NSLayoutYAxisAnchor { get }

    var lastBaselineAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutContainer {
    public var layout: Layout {
        translatesAutoresizingMaskIntoConstraints = false
        return Layout(self)
    }

    public var parentContainer: LayoutContainer {
        superview!
    }
}

extension UILayoutGuide: LayoutContainer {
    public var layout: Layout {
        Layout(self)
    }

    public var parentContainer: LayoutContainer {
        owningView!
    }

    public var firstBaselineAnchor: NSLayoutYAxisAnchor {
        topAnchor
    }

    public var lastBaselineAnchor: NSLayoutYAxisAnchor {
        bottomAnchor
    }
}

func foo() {
    UIView()
        .layout
        .alignEdges().priority(.defaultHigh)
//        .width(10)
//        .width(.greaterThanOrEqual, to: 10)
//        .width()
//        .width(.lessThanOrEqual, to: UIView().widthAnchor)
//        .width(multiplier: 2)
//        .width(constant: 2)
//        .size(CGSize(width: 100, height: 100))
        .height(10)
        .height(.equal, to: 10)
        .aspectRatio(CGSize(width: 100, height: 66))
        .activate()
}
