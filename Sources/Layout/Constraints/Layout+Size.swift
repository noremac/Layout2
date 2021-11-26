#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

// MARK: Width

public extension Layout {
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
}

// MARK: Height

public extension Layout {
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
}

// MARK: Size

public extension Layout {
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
}

// MARK: Aspect ratio

public extension Layout {
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

// MARK: - Relation helpers

extension NSLayoutDimension {
    @inlinable
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

    @inlinable
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
