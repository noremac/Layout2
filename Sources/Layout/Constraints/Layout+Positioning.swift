#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

// MARK: Edges

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
                        greaterThanOrEqualTo: (secondItem ?? firstItem.parentContainer).topAnchor,
                        constant: insets.top
                    )
            )
        }

        if edges.contains(.leading) {
            constraints.append(
                firstItem
                    .leadingAnchor
                    .constraint(
                        greaterThanOrEqualTo: (secondItem ?? firstItem.parentContainer).leadingAnchor,
                        constant: insets.leading
                    )
            )
        }

        if edges.contains(.bottom) {
            constraints.append(
                firstItem
                    .bottomAnchor
                    .constraint(
                        lessThanOrEqualTo: (secondItem ?? firstItem.parentContainer).bottomAnchor,
                        constant: -insets.bottom
                    )
            )
        }

        if edges.contains(.trailing) {
            constraints.append(
                firstItem
                    .trailingAnchor
                    .constraint(
                        lessThanOrEqualTo: (secondItem ?? firstItem.parentContainer).trailingAnchor,
                        constant: -insets.trailing
                    )
            )
        }

        return addConstraints(constraints)
    }
}

public extension Layout {
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
}

extension NSLayoutYAxisAnchor {
    @inlinable
    func constraint(
        withRelation relation: Layout.Relation,
        to otherAnchor: NSLayoutYAxisAnchor,
        constant: CGFloat
    ) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return constraint(equalTo: otherAnchor, constant: constant)
        case .lessThanOrEqual:
            return constraint(lessThanOrEqualTo: otherAnchor, constant: constant)
        case .greaterThanOrEqual:
            return constraint(greaterThanOrEqualTo: otherAnchor, constant: constant)
        }
    }
}

extension NSLayoutXAxisAnchor {
    @inlinable
    func constraint(
        withRelation relation: Layout.Relation,
        to otherAnchor: NSLayoutXAxisAnchor,
        constant: CGFloat
    ) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return constraint(equalTo: otherAnchor, constant: constant)
        case .lessThanOrEqual:
            return constraint(lessThanOrEqualTo: otherAnchor, constant: constant)
        case .greaterThanOrEqual:
            return constraint(greaterThanOrEqualTo: otherAnchor, constant: constant)
        }
    }
}