#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public final class DynamicLayout<State> {
    private let mainScope = Scope(.always)

    private var activeConstraints: Set<NSLayoutConstraint> = []

    public init() {}

    public func configure(file: StaticString = #file, line: UInt = #line, _ configure: (Configuration) -> Void) {
        guard !mainScope.hasConstraintsOrActions else {
            fatalError("\(#function) should only be called once.", file: file, line: line)
        }
        configure(Configuration(mainScope))
    }

    public func update(state: State) {
        let contexts = mainScope.activeScopes(for: state)
        let (newConstraints, actions) = contexts.reduce(into: ([NSLayoutConstraint](), [(State) -> Void]())) { result, context in
            result.0 += context.constraints
            result.1 += context.actions
        }
        let newSet = Set(newConstraints)
        var constraintsToDeactivate = [NSLayoutConstraint]()
        var constraintsToActivate = [NSLayoutConstraint]()
        for newConstraint in newSet {
            if !activeConstraints.contains(newConstraint) {
                constraintsToActivate.append(newConstraint)
            }
        }
        for oldConstraint in activeConstraints {
            if !newSet.contains(oldConstraint) {
                constraintsToDeactivate.append(oldConstraint)
            }
        }
        NSLayoutConstraint.deactivate(constraintsToDeactivate)
        NSLayoutConstraint.activate(constraintsToActivate)
        activeConstraints = newSet
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

    init(_ value: State) where State: Equatable {
        self.init({ state in
            state == value
        })
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

    func when(_ value: State, _ whenBlock: () -> Void, otherwise otherwiseBlock: () -> Void) where State: Equatable {
        when(.init(value), whenBlock, otherwise: otherwiseBlock)
    }

    func when(_ value: State, _ whenBlock: () -> Void) where State: Equatable {
        when(.init(value), whenBlock)
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
    public static func buildBlock(_ components: Layout...) -> [NSLayoutConstraint] {
        components.flatMap(\._constraints)
    }
}
