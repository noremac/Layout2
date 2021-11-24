#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

// MARK: - Edges

public extension Layout {

    // MARK: Top

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

    // MARK: Leading

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

    // MARK: Bottom

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

    // MARK: Trailing

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

    // MARK: Align

    @inlinable
    func alignEdges(
        _ edges: NSDirectionalRectEdge = .all,
        to secondItem: LayoutContainer? = nil,
        insets: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    ) -> Layout {
        merge {
            if edges.contains(.top) {
                self.top(
                    to: (secondItem ?? firstItem.parentContainer).topAnchor,
                    constant: insets.top
                )
            }

            if edges.contains(.leading) {
                leading(
                    to: (secondItem ?? firstItem.parentContainer).leadingAnchor,
                    constant: insets.leading
                )
            }

            if edges.contains(.bottom) {
                bottom(
                    to: (secondItem ?? firstItem.parentContainer).bottomAnchor,
                    constant: -insets.bottom
                )
            }

            if edges.contains(.trailing) {
                trailing(
                    to: (secondItem ?? firstItem.parentContainer).trailingAnchor,
                    constant: -insets.trailing
                )
            }
        }
    }

    // MARK: Contain

    @inlinable
    func containEdges(
        _ edges: NSDirectionalRectEdge,
        within secondItem: LayoutContainer? = nil,
        insets: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    ) -> Layout {
        merge {
            if edges.contains(.top) {
                self.top(
                    .greaterThanOrEqual,
                    to: (secondItem ?? firstItem.parentContainer).topAnchor,
                    constant: insets.top
                )
            }

            if edges.contains(.leading) {
                leading(
                    .greaterThanOrEqual,
                    to: (secondItem ?? firstItem.parentContainer).leadingAnchor,
                    constant: insets.leading
                )
            }

            if edges.contains(.bottom) {
                bottom(
                    .lessThanOrEqual,
                    to: (secondItem ?? firstItem.parentContainer).bottomAnchor,
                    constant: -insets.bottom
                )
            }

            if edges.contains(.trailing) {
                trailing(
                    .lessThanOrEqual,
                    to: (secondItem ?? firstItem.parentContainer).trailingAnchor,
                    constant: -insets.trailing
                )
            }
        }
    }
}

// MARK: - Centering

public extension Layout {

    // MARK: X

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

    // MARK: Y

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

    // MARK: X/Y

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

// MARK: - Relation helpers

extension NSLayoutYAxisAnchor {
    @inlinable
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
    @inlinable
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
