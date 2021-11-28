#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public final class Layout {
    public var firstItem: LayoutContainer

    public internal(set) var constraints: [NSLayoutConstraint] = []

    var _lastAddedConstraints: [NSLayoutConstraint] = []

    public init(_ firstItem: LayoutContainer) {
        self.firstItem = firstItem
    }
}

public extension Layout {
    enum Relation {
        case equal
        case lessThanOrEqual
        case greaterThanOrEqual
    }
}

public extension Layout {
    func addConstraints(_ constraints: [NSLayoutConstraint]) -> Layout {
        self.constraints.append(contentsOf: constraints)
        _lastAddedConstraints = constraints
        return self
    }

    func addConstraint(_ constraint: NSLayoutConstraint) -> Layout {
        addConstraints([constraint])
    }

    @discardableResult
    func activate() -> [NSLayoutConstraint] {
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    #if canImport(UIKit)
    func priority(_ priority: UILayoutPriority) -> Layout {
        _lastAddedConstraints.forEach { constraint in
            constraint.priority = priority
        }
        return self
    }

    #elseif canImport(AppKit)
    func priority(_ priority: NSLayoutConstraint.Priority) -> Layout {
        _lastAddedConstraints.forEach { constraint in
            constraint.priority = priority
        }
        return self
    }
    #endif
    func identifier(_ identifier: String?) -> Layout {
        _lastAddedConstraints.forEach { constraint in
            constraint.identifier = identifier
        }
        return self
    }
}
