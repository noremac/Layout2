@MainActor
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

#if canImport(UIKit)
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
#endif

#if canImport(AppKit)
extension NSView: LayoutContainer {
    public var layout: Layout {
        translatesAutoresizingMaskIntoConstraints = false
        return Layout(self)
    }

    public var parentContainer: LayoutContainer {
        superview!
    }
}

extension NSLayoutGuide: LayoutContainer {
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
#endif
