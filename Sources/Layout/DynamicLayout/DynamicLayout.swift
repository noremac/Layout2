#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public final class DynamicLayout<State> {
    private let mainScope = Scope(.always)

    @_spi(Testing)
    public var activeConstraints: Set<NSLayoutConstraint> = []

    public init() {}

    public func configure(file: StaticString = #file, line: UInt = #line, _ configure: (Configuration) -> Void) {
        guard !mainScope.hasConstraintsOrActions else {
            fatalError("\(#function) should only be called once.", file: file, line: line)
        }
        configure(Configuration(mainScope))
    }

    public func update(state: State) {
        let contexts = mainScope.activeScopes(for: state)
        let (newConstraints, actions) = contexts.reduce(into: (Set<NSLayoutConstraint>(), [(State) -> Void]())) { result, context in
            result.0.formUnion(context.constraints)
            result.1 += context.actions
        }
        let constraintsToActivate = newConstraints.reduce(into: [NSLayoutConstraint]()) { acc, newConstraint in
            if !activeConstraints.contains(newConstraint) {
                acc.append(newConstraint)
            }
        }
        let constraintsToDeactivate = activeConstraints.reduce(into: [NSLayoutConstraint]()) { acc, oldConstraint in
            if !newConstraints.contains(oldConstraint) {
                acc.append(oldConstraint)
            }
        }
        NSLayoutConstraint.deactivate(constraintsToDeactivate)
        NSLayoutConstraint.activate(constraintsToActivate)
        activeConstraints = newConstraints
        actions.forEach { $0(state) }
    }
}

public extension DynamicLayout {
    struct Predicate {
        let closure: (State) -> Bool
    }
}

public extension DynamicLayout.Predicate {
    init(_ closure: @escaping (State) -> Bool) {
        self.closure = closure
    }

    internal static var always: Self {
        self.init({ _ in true })
    }
}

extension DynamicLayout {
    final class Scope {
        let predicate: Predicate
        var constraints: [NSLayoutConstraint] = []
        var actions: [(State) -> Void] = []
        var children: [Scope] = []
        var otherwise: Scope?

        init(_ predicate: DynamicLayout.Predicate) {
            self.predicate = predicate
        }
    }
}

extension DynamicLayout.Scope {
    var hasConstraintsOrActions: Bool {
        if otherwise != nil {
            return true
        }

        if !constraints.isEmpty || !actions.isEmpty {
            return true
        }

        return children.contains(where: \.hasConstraintsOrActions)
    }

    func activeScopes(for state: State) -> [DynamicLayout.Scope] {
        if predicate.closure(state) {
            return children.reduce(into: [self], { $0 += $1.activeScopes(for: state) })
        }
        return otherwise?.activeScopes(for: state) ?? []
    }
}

public extension DynamicLayout {
    final class Configuration {
        var currentScope: Scope

        init(_ currentScope: Scope) {
            self.currentScope = currentScope
        }
    }
}

public extension DynamicLayout.Configuration {
    func when(_ predicate: DynamicLayout.Predicate, _ whenBlock: () -> Void, otherwise otherwiseBlock: () -> Void) {
        let previousScope = currentScope
        defer {
            currentScope = previousScope
        }

        let newScope = DynamicLayout.Scope(predicate)
        currentScope = newScope
        whenBlock()

        let newOtherwise = DynamicLayout.Scope(.always)
        currentScope = newOtherwise
        otherwiseBlock()

        if newOtherwise.hasConstraintsOrActions {
            newScope.otherwise = newOtherwise
        }

        if newScope.hasConstraintsOrActions {
            previousScope.children.append(newScope)
        }
    }

    func when(_ predicate: DynamicLayout.Predicate, _ whenBlock: () -> Void) {
        when(predicate, whenBlock, otherwise: {})
    }

    func when(_ predicate: @escaping (State) -> Bool, _ whenBlock: () -> Void, otherwise otherwiseBlock: () -> Void) where State: Equatable {
        when(.init(predicate), whenBlock, otherwise: otherwiseBlock)
    }

    func when(_ predicate: @escaping (State) -> Bool, _ whenBlock: () -> Void) where State: Equatable {
        when(.init(predicate), whenBlock)
    }

    func when(_ value: State, _ whenBlock: () -> Void, otherwise otherwiseBlock: () -> Void) where State: Equatable {
        when({ $0 == value }, whenBlock, otherwise: otherwiseBlock)
    }

    func when(_ value: State, _ whenBlock: () -> Void) where State: Equatable {
        when({ $0 == value }, whenBlock)
    }
}

public extension DynamicLayout.Configuration {
    func action(_ action: @escaping (State) -> Void) {
        currentScope.actions.append(action)
    }

    func action(_ action: @escaping () -> Void) {
        self.action { _ in
            action()
        }
    }
}

public extension DynamicLayout.Configuration {
    func constraints(@DynamicLayoutConstraintBuilder _ constraints: () -> [NSLayoutConstraint]) {
        currentScope.constraints += constraints()
    }
}

@resultBuilder
public enum DynamicLayoutConstraintBuilder {
    public static func buildExpression(_ expression: NSLayoutConstraint) -> [NSLayoutConstraint] {
        [expression]
    }

    public static func buildExpression(_ expression: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        expression
    }

    public static func buildExpression(_ expression: Layout) -> [NSLayoutConstraint] {
        expression.constraints
    }

    public static func buildBlock(_ components: [NSLayoutConstraint]...) -> [NSLayoutConstraint] {
        components.flatMap({ $0 })
    }
}
