#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

// MARK: Layout

public final class Layout: Hashable {
    public var firstItem: LayoutContainer

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

    public static func == (lhs: Layout, rhs: Layout) -> Bool {
        lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
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
    func merge(@MultiLayoutBuilder _ layout: () -> Layout) -> Layout {
        layout()
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

@resultBuilder
public enum MultiLayoutBuilder {
    public typealias Component = Layout

    #if canImport(UIKit)
    @usableFromInline
    static let dummyView = UIView()
    #elseif canImport(AppKit)
    @usableFromInline
    static let dummyView = NSView()
    #endif

    @inlinable
    static func buildBlock(_ components: Layout...) -> Layout {
        guard let first = components.first else {
            return Layout(dummyView)
        }

        let set = Set(components)

        if set.count == 1 {
            return first
        } else {
            return set.subtracting([first]).reduce(into: first) { acc, next in
                acc._constraints += next._constraints
            }
        }
    }

    @inlinable
    public static func buildOptional(_ component: Layout?) -> Layout {
        component ?? Layout(dummyView)
    }
}
