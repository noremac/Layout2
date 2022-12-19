#if canImport(AppKit)
@_exported import AppKit

public typealias _LayoutPriority = NSLayoutConstraint.Priority
#elseif canImport(UIKit)
@_exported import UIKit

public typealias _LayoutPriority = UILayoutPriority
#else
#error("Unsupported platform")
#endif

@MainActor
public struct Layout {
  public var firstItem: LayoutContainer

  public var constraints: [NSLayoutConstraint] = []

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
  func addConstraints(
    _ newConstraints: some Collection<NSLayoutConstraint>,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    var layout = self
    let startIndex = layout.constraints.endIndex
    layout.constraints.append(contentsOf: newConstraints)

    lazy var actualIdentifier = identifier ?? "\((file as NSString).lastPathComponent):\(line)"
    for constraint in layout.constraints[startIndex...] {
      if let priority {
        constraint.priority = priority
      }
      constraint.identifier = actualIdentifier
    }
    return layout
  }

  @inlinable
  func addConstraint(
    _ newConstraint: NSLayoutConstraint,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraints(
      CollectionOfOne(newConstraint),
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  @discardableResult
  func activate() -> [NSLayoutConstraint] {
    NSLayoutConstraint.activate(constraints)
    return constraints
  }

  @inlinable
  func top(
    _ relation: Relation = .equal,
    to anchor: NSLayoutYAxisAnchor? = nil,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraint(
      firstItem
        .topAnchor
        .constraint(
          withRelation: relation,
          to: anchor ?? firstItem.parentContainer.topAnchor,
          constant: constant
        ),
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func top(
    _ relation: Relation = .equal,
    to anchor: LayoutContainer,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    top(
      relation,
      to: anchor.topAnchor,
      constant: constant,
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func leading(
    _ relation: Relation = .equal,
    to anchor: NSLayoutXAxisAnchor? = nil,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraint(
      firstItem
        .leadingAnchor
        .constraint(
          withRelation: relation,
          to: anchor ?? firstItem.parentContainer.leadingAnchor,
          constant: constant
        ),
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func leading(
    _ relation: Relation = .equal,
    to anchor: LayoutContainer,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    leading(
      relation,
      to: anchor.leadingAnchor,
      constant: constant,
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func bottom(
    _ relation: Relation = .equal,
    to anchor: NSLayoutYAxisAnchor? = nil,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraint(
      firstItem
        .bottomAnchor
        .constraint(
          withRelation: relation,
          to: anchor ?? firstItem.parentContainer.bottomAnchor,
          constant: constant
        ),
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func bottom(
    _ relation: Relation = .equal,
    to anchor: LayoutContainer,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    bottom(
      relation,
      to: anchor.bottomAnchor,
      constant: constant,
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func trailing(
    _ relation: Relation = .equal,
    to anchor: NSLayoutXAxisAnchor? = nil,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraint(
      firstItem
        .trailingAnchor
        .constraint(
          withRelation: relation,
          to: anchor ?? firstItem.parentContainer.trailingAnchor,
          constant: constant
        ),
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func trailing(
    _ relation: Relation = .equal,
    to anchor: LayoutContainer,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    trailing(
      relation,
      to: anchor.trailingAnchor,
      constant: constant,
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func alignEdges(
    _ edges: NSDirectionalRectEdge = .all,
    to secondItem: LayoutContainer? = nil,
    insets: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
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

    return addConstraints(
      constraints,
      priority: nil,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func containEdges(
    _ edges: NSDirectionalRectEdge,
    within secondItem: LayoutContainer? = nil,
    insets: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
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

    return addConstraints(
      constraints,
      priority: nil,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func centerX(
    _ relation: Relation = .equal,
    to anchor: NSLayoutXAxisAnchor? = nil,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraint(
      firstItem
        .centerXAnchor
        .constraint(
          withRelation: relation,
          to: anchor ?? firstItem.parentContainer.centerXAnchor,
          constant: constant
        ),
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func centerY(
    _ relation: Relation = .equal,
    to anchor: NSLayoutYAxisAnchor? = nil,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraint(
      firstItem
        .centerYAnchor
        .constraint(
          withRelation: relation,
          to: anchor ?? firstItem.parentContainer.centerYAnchor,
          constant: constant
        ),
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func center(
    within secondItem: LayoutContainer? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraints(
      [
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
      ],
      priority: nil,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func width(
    _ relation: Relation = .equal,
    to secondItem: NSLayoutDimension? = nil,
    multiplier: Double = 1,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraint(
      firstItem
        .widthAnchor
        .constraint(
          withRelation: relation,
          to: secondItem ?? firstItem.parentContainer.widthAnchor,
          multiplier: multiplier,
          constant: constant
        ),
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func width(
    _ relation: Relation,
    to constant: Double,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraint(
      firstItem.widthAnchor.constraint(withRelation: relation, constant: constant),
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func width(
    _ constant: Double,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    width(
      .equal,
      to: constant,
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func height(
    _ relation: Relation = .equal,
    to secondItem: NSLayoutDimension? = nil,
    multiplier: Double = 1,
    constant: Double = 0,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraint(
      firstItem
        .heightAnchor
        .constraint(
          withRelation: relation,
          to: secondItem ?? firstItem.parentContainer.heightAnchor,
          multiplier: multiplier,
          constant: constant
        ),
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func height(
    _ relation: Relation,
    to constant: Double,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraint(
      firstItem.heightAnchor.constraint(withRelation: relation, constant: constant),
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func height(
    _ constant: Double,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    height(
      .equal,
      to: constant,
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func size(
    _ relation: Relation,
    to size: CGSize,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraints(
      [
        firstItem.widthAnchor.constraint(withRelation: relation, constant: size.width),
        firstItem.heightAnchor.constraint(withRelation: relation, constant: size.height),
      ],
      priority: nil,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func size(
    _ size: CGSize,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    self.size(.equal, to: size)
  }

  @inlinable
  func matchSize(
    _ relation: Relation = .equal,
    to secondItem: LayoutContainer? = nil,
    multiplier: Double = 1,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    addConstraints(
      [
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
      ],
      priority: nil,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func aspectRatio(
    _ size: CGSize,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    aspectRatio(
      size.width / size.height,
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }

  @inlinable
  func aspectRatio(
    _ ratio: Double,
    priority: _LayoutPriority? = nil,
    identifier: String? = nil,
    file: String = #file,
    line: UInt = #line
  ) -> Layout {
    width(
      .equal,
      to: firstItem.heightAnchor,
      multiplier: ratio,
      priority: priority,
      identifier: identifier,
      file: file,
      line: line
    )
  }
}

extension NSLayoutYAxisAnchor {
  @usableFromInline
  func constraint(
    withRelation relation: Layout.Relation,
    to otherAnchor: NSLayoutYAxisAnchor,
    constant: Double
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
    constant: Double
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
    constant: Double
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
    multiplier: Double,
    constant: Double
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
