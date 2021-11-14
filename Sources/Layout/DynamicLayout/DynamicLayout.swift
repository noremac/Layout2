import UIKit

public final class DynamicLayout<State> {
    private let scope = Scope(.always)

    public func configure(_ configure: (inout Configuration) -> Void) {
        var cfg = Configuration(scope)
        configure(&cfg)
    }
}

// MARK: Scope

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

        var hasConstraintsOrActions: Bool {
            if otherwise != nil {
                return true
            }

            if !constraints.isEmpty || !actions.isEmpty {
                return true
            }

            return children.contains(where: \.hasConstraintsOrActions)
        }
    }
}

// MARK: Predicate

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

// MARK: Configuration

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

    func when(_ value: State, _ whenBlock: () -> Void, otherwise otherwiseBlock: () -> Void) where State: Equatable {
        when(.init(value), whenBlock, otherwise: otherwiseBlock)
    }

    func when(_ predicate: DynamicLayout.Predicate, _ whenBlock: () -> Void) {
        let previousScope = currentScope
        defer {
            currentScope = previousScope
        }

        let newScope = DynamicLayout.Scope(predicate)
        currentScope = newScope
        whenBlock()

        if newScope.hasConstraintsOrActions {
            previousScope.children.append(newScope)
        }
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
public struct DynamicLayoutConstraintBuilder {
    public static func buildBlock(_ components: Layout...) -> [NSLayoutConstraint] {
        components.flatMap(\._constraints)
    }
}
