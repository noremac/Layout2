import UIKit

public final class Layout {
    public let firstItem: LayoutContainer

    @usableFromInline
    internal var _constraints: [NSLayoutConstraint] = []

    @usableFromInline
    internal var _lastAddedConstraints: [NSLayoutConstraint] = []

    public init(_ firstItem: LayoutContainer) {
        self.firstItem = firstItem
    }

    @inlinable
    public var constraints: [NSLayoutConstraint] {
        _constraints
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
    @inlinable
    func addConstraint(_ constraint: NSLayoutConstraint) -> Layout {
        addConstraints([constraint])
    }

    @inlinable
    func addConstraints(_ constraints: [NSLayoutConstraint]) -> Layout {
        _constraints.append(contentsOf: constraints)
        _lastAddedConstraints = constraints
        return self
    }

    @inlinable
    @discardableResult
    func activate() -> [NSLayoutConstraint] {
        NSLayoutConstraint.activate(_constraints)
        return _constraints
    }

    @inlinable
    func priority(_ priority: UILayoutPriority) -> Layout {
        _lastAddedConstraints.forEach { constraint in
            constraint.priority = priority
        }
        return self
    }

    @inlinable
    func identifier(_ identifier: String?) -> Layout {
        _lastAddedConstraints.forEach { constraint in
            constraint.identifier = identifier
        }
        return self
    }
}
