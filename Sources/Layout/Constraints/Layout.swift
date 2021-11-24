#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

// MARK: Layout

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

// MARK: Relation

public extension Layout {
    enum Relation {
        case equal
        case lessThanOrEqual
        case greaterThanOrEqual
    }
}

// MARK: Building blocks

public extension Layout {
    @inlinable
    func addConstraints(_ constraints: [NSLayoutConstraint]) -> Layout {
        _constraints.append(contentsOf: constraints)
        _lastAddedConstraints = constraints
        return self
    }

    @inlinable
    func addConstraint(_ constraint: NSLayoutConstraint) -> Layout {
        addConstraints([constraint])
    }

    @inlinable
    @discardableResult
    func activate() -> [NSLayoutConstraint] {
        NSLayoutConstraint.activate(_constraints)
        return _constraints
    }

    #if canImport(UIKit)
    @inlinable
    func priority(_ priority: UILayoutPriority) -> Layout {
        _lastAddedConstraints.forEach { constraint in
            constraint.priority = priority
        }
        return self
    }
    #elseif canImport(AppKit)
    @inlinable
    func priority(_ priority: NSLayoutConstraint.Priority) -> Layout {
        _lastAddedConstraints.forEach { constraint in
            constraint.priority = priority
        }
        return self
    }
    #endif

    @inlinable
    func identifier(_ identifier: String?) -> Layout {
        _lastAddedConstraints.forEach { constraint in
            constraint.identifier = identifier
        }
        return self
    }
}

public extension Layout {
    @inlinable
    func addLayouts(@MultiLayoutBuilder _ layouts: () -> [Layout]) -> Layout {
        addConstraints(layouts().flatMap(\._constraints))
    }
}

@resultBuilder
public struct MultiLayoutBuilder {
    public typealias Expression = Layout
    public typealias Component = [Expression]

    @inlinable
    public static func buildExpression(_ expression: Layout) -> [Layout] {
        [expression]
    }

    @inlinable
    static func buildBlock(_ components: [Layout]...) -> [Layout] {
        components.flatMap({ $0 })
    }

    @inlinable
    public static func buildOptional(_ component: [Layout]?) -> [Layout] {
        component ?? []
    }
}
