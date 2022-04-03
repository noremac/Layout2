#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public struct Layout {
    public var firstItem: LayoutContainer

    public var constraints: [NSLayoutConstraint] = []

    @usableFromInline
    var lastAdditionStartIndex: Int?

    init(_ firstItem: LayoutContainer) {
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
    @inlinable
    func addConstraints(_ newConstraints: [NSLayoutConstraint]) -> Layout {
        var layout = self
        layout.lastAdditionStartIndex = constraints.endIndex
        layout.constraints.append(contentsOf: newConstraints)
        return layout
    }

    @inlinable
    func addConstraint(_ newConstraint: NSLayoutConstraint) -> Layout {
        var layout = self
        layout.lastAdditionStartIndex = constraints.endIndex
        layout.constraints.append(newConstraint)
        return layout
    }

    @inlinable
    @discardableResult
    func activate() -> [NSLayoutConstraint] {
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    #if canImport(UIKit)
    @inlinable
    func priority(_ priority: UILayoutPriority) -> Layout {
        if let startIndex = lastAdditionStartIndex {
            for constraint in constraints[startIndex...] {
                constraint.priority = priority
            }
        }
        return self
    }
    #elseif canImport(AppKit)
    @inlinable
    func priority(_ priority: NSLayoutConstraint.Priority) -> Layout {
        if let startIndex = lastAdditionStartIndex {
            for constraint in constraints[startIndex...] {
                constraint.priority = priority
            }
        }
        return self
    }
    #endif

    @inlinable
    func identifier(_ identifier: String?) -> Layout {
        if let startIndex = lastAdditionStartIndex {
            for constraint in constraints[startIndex...] {
                constraint.identifier = identifier
            }
        }
        return self
    }
}

public extension Layout {
    @inlinable
    func top(
        _ relation: Relation = .equal,
        to anchor: NSLayoutYAxisAnchor? = nil,
        constant: CGFloat = 0
    ) -> Layout {
        addConstraint(
            firstItem
                .topAnchor
                .constraint(
                    withRelation: relation,
                    to: anchor ?? firstItem.parentContainer.topAnchor,
                    constant: constant
                )
        )
    }

    @inlinable
    func leading(
        _ relation: Relation = .equal,
        to anchor: NSLayoutXAxisAnchor? = nil,
        constant: CGFloat = 0
    ) -> Layout {
        addConstraint(
            firstItem
                .leadingAnchor
                .constraint(
                    withRelation: relation,
                    to: anchor ?? firstItem.parentContainer.leadingAnchor,
                    constant: constant
                )
        )
    }

    @inlinable
    func bottom(
        _ relation: Relation = .equal,
        to anchor: NSLayoutYAxisAnchor? = nil,
        constant: CGFloat = 0
    ) -> Layout {
        addConstraint(
            firstItem
                .bottomAnchor
                .constraint(
                    withRelation: relation,
                    to: anchor ?? firstItem.parentContainer.bottomAnchor,
                    constant: constant
                )
        )
    }

    @inlinable
    func trailing(
        _ relation: Relation = .equal,
        to anchor: NSLayoutXAxisAnchor? = nil,
        constant: CGFloat = 0
    ) -> Layout {
        addConstraint(
            firstItem
                .trailingAnchor
                .constraint(
                    withRelation: relation,
                    to: anchor ?? firstItem.parentContainer.trailingAnchor,
                    constant: constant
                )
        )
    }

    @inlinable
    func alignEdges(
        _ edges: NSDirectionalRectEdge = .all,
        to secondItem: LayoutContainer? = nil,
        insets: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    ) -> Layout {
        var constraints = [NSLayoutConstraint]()

        if edges.contains(.top) {
            constraints.append(
                firstItem
                    .topAnchor
                    .constraint(
                        equalTo: (secondItem ?? firstItem.parentContainer).topAnchor,
                        constant: insets.top
                    )
            )
        }

        if edges.contains(.leading) {
            constraints.append(
                firstItem
                    .leadingAnchor
                    .constraint(
                        equalTo: (secondItem ?? firstItem.parentContainer).leadingAnchor,
                        constant: insets.leading
                    )
            )
        }

        if edges.contains(.bottom) {
            constraints.append(
                firstItem
                    .bottomAnchor
                    .constraint(
                        equalTo: (secondItem ?? firstItem.parentContainer).bottomAnchor,
                        constant: -insets.bottom
                    )
            )
        }

        if edges.contains(.trailing) {
            constraints.append(
                firstItem
                    .trailingAnchor
                    .constraint(
                        equalTo: (secondItem ?? firstItem.parentContainer).trailingAnchor,
                        constant: -insets.trailing
                    )
            )
        }

        return addConstraints(constraints)
    }

    @inlinable
    func containEdges(
        _ edges: NSDirectionalRectEdge,
        within secondItem: LayoutContainer? = nil,
        insets: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    ) -> Layout {
        var constraints = [NSLayoutConstraint]()

        if edges.contains(.top) {
            constraints.append(
                firstItem
                    .topAnchor
                    .constraint(
                        withRelation: .greaterThanOrEqual,
                        to: (secondItem ?? firstItem.parentContainer).topAnchor,
                        constant: insets.top
                    )
            )
        }

        if edges.contains(.leading) {
            constraints.append(
                firstItem
                    .leadingAnchor
                    .constraint(
                        withRelation: .greaterThanOrEqual,
                        to: (secondItem ?? firstItem.parentContainer).leadingAnchor,
                        constant: insets.leading
                    )
            )
        }

        if edges.contains(.bottom) {
            constraints.append(
                firstItem
                    .bottomAnchor
                    .constraint(
                        withRelation: .lessThanOrEqual,
                        to: (secondItem ?? firstItem.parentContainer).bottomAnchor,
                        constant: -insets.bottom
                    )
            )
        }

        if edges.contains(.trailing) {
            constraints.append(
                firstItem
                    .trailingAnchor
                    .constraint(
                        withRelation: .lessThanOrEqual,
                        to: (secondItem ?? firstItem.parentContainer).trailingAnchor,
                        constant: -insets.trailing
                    )
            )
        }

        return addConstraints(constraints)
    }

    @inlinable
    func centerX(
        _ relation: Relation = .equal,
        to anchor: NSLayoutXAxisAnchor? = nil,
        constant: CGFloat = 0
    ) -> Layout {
        addConstraint(
            firstItem
                .centerXAnchor
                .constraint(
                    withRelation: relation,
                    to: anchor ?? firstItem.parentContainer.centerXAnchor,
                    constant: constant
                )
        )
    }

    @inlinable
    func centerY(
        _ relation: Relation = .equal,
        to anchor: NSLayoutYAxisAnchor? = nil,
        constant: CGFloat = 0
    ) -> Layout {
        addConstraint(
            firstItem
                .centerYAnchor
                .constraint(
                    withRelation: relation,
                    to: anchor ?? firstItem.parentContainer.centerYAnchor,
                    constant: constant
                )
        )
    }

    @inlinable
    func center(
        within secondItem: LayoutContainer? = nil
    ) -> Layout {
        addConstraints([
            firstItem
                .centerXAnchor
                .constraint(
                    equalTo: (secondItem ?? firstItem.parentContainer).centerXAnchor
                ),
            firstItem
                .centerYAnchor
                .constraint(
                    equalTo: (secondItem ?? firstItem.parentContainer).centerYAnchor
                ),
        ])
    }

    @inlinable
    func matchWidth(
        _ relation: Relation = .equal,
        to secondItem: NSLayoutDimension? = nil,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) -> Layout {
        addConstraint(
            firstItem
                .widthAnchor
                .constraint(
                    withRelation: relation,
                    to: secondItem ?? firstItem.parentContainer.widthAnchor,
                    multiplier: multiplier,
                    constant: constant
                )
        )
    }

    @inlinable
    func width(
        _ relation: Relation,
        to constant: CGFloat
    ) -> Layout {
        addConstraint(firstItem.widthAnchor.constraint(withRelation: relation, constant: constant))
    }

    @inlinable
    func width(
        _ constant: CGFloat
    ) -> Layout {
        width(.equal, to: constant)
    }

    @inlinable
    func matchHeight(
        _ relation: Relation = .equal,
        to secondItem: NSLayoutDimension? = nil,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) -> Layout {
        addConstraint(
            firstItem
                .heightAnchor
                .constraint(
                    withRelation: relation,
                    to: secondItem ?? firstItem.parentContainer.heightAnchor,
                    multiplier: multiplier,
                    constant: constant
                )
        )
    }

    @inlinable
    func height(
        _ relation: Relation,
        to constant: CGFloat
    ) -> Layout {
        addConstraint(firstItem.heightAnchor.constraint(withRelation: relation, constant: constant))
    }

    @inlinable
    func height(
        _ constant: CGFloat
    ) -> Layout {
        height(.equal, to: constant)
    }

    @inlinable
    func size(
        _ relation: Relation,
        to size: CGSize
    ) -> Layout {
        addConstraints([
            firstItem.widthAnchor.constraint(withRelation: relation, constant: size.width),
            firstItem.heightAnchor.constraint(withRelation: relation, constant: size.height),
        ])
    }

    @inlinable
    func size(
        _ size: CGSize
    ) -> Layout {
        self.size(.equal, to: size)
    }

    @inlinable
    func matchSize(
        _ relation: Relation = .equal,
        to secondItem: LayoutContainer? = nil,
        multiplier: CGFloat = 1
    ) -> Layout {
        addConstraints([
            firstItem
                .widthAnchor
                .constraint(
                    withRelation: relation,
                    to: (secondItem ?? firstItem.parentContainer).widthAnchor,
                    multiplier: multiplier,
                    constant: 0
                ),
            firstItem
                .heightAnchor
                .constraint(
                    withRelation: relation,
                    to: (secondItem ?? firstItem.parentContainer).heightAnchor,
                    multiplier: multiplier,
                    constant: 0
                ),
        ])
    }

    @inlinable
    func aspectRatio(
        _ size: CGSize
    ) -> Layout {
        aspectRatio(size.width / size.height)
    }

    @inlinable
    func aspectRatio(
        _ ratio: CGFloat
    ) -> Layout {
        matchWidth(.equal, to: firstItem.heightAnchor, multiplier: ratio)
    }
}

extension NSLayoutYAxisAnchor {
    @usableFromInline
    func constraint(
        withRelation relation: Layout.Relation,
        to otherAnchor: NSLayoutYAxisAnchor,
        constant: CGFloat
    ) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return constraint(
                equalTo: otherAnchor,
                constant: constant
            )
        case .lessThanOrEqual:
            return constraint(
                lessThanOrEqualTo: otherAnchor,
                constant: constant
            )
        case .greaterThanOrEqual:
            return constraint(
                greaterThanOrEqualTo: otherAnchor,
                constant: constant
            )
        }
    }
}

extension NSLayoutXAxisAnchor {
    @usableFromInline
    func constraint(
        withRelation relation: Layout.Relation,
        to otherAnchor: NSLayoutXAxisAnchor,
        constant: CGFloat
    ) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return constraint(
                equalTo: otherAnchor,
                constant: constant
            )
        case .lessThanOrEqual:
            return constraint(
                lessThanOrEqualTo: otherAnchor,
                constant: constant
            )
        case .greaterThanOrEqual:
            return constraint(
                greaterThanOrEqualTo: otherAnchor,
                constant: constant
            )
        }
    }
}

extension NSLayoutDimension {
    @usableFromInline
    func constraint(
        withRelation relation: Layout.Relation,
        constant: CGFloat
    ) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return constraint(equalToConstant: constant)
        case .lessThanOrEqual:
            return constraint(lessThanOrEqualToConstant: constant)
        case .greaterThanOrEqual:
            return constraint(greaterThanOrEqualToConstant: constant)
        }
    }

    @usableFromInline
    func constraint(
        withRelation relation: Layout.Relation,
        to otherAnchor: NSLayoutDimension,
        multiplier: CGFloat,
        constant: CGFloat
    ) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return constraint(
                equalTo: otherAnchor,
                multiplier: multiplier,
                constant: constant
            )
        case .lessThanOrEqual:
            return constraint(
                lessThanOrEqualTo: otherAnchor,
                multiplier: multiplier,
                constant: constant
            )
        case .greaterThanOrEqual:
            return constraint(
                greaterThanOrEqualTo: otherAnchor,
                multiplier: multiplier,
                constant: constant
            )
        }
    }
}

