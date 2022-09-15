@MainActor
@resultBuilder
public enum ConstraintBuilder {
    public typealias Component = [NSLayoutConstraint]

    public static func buildExpression(_ expression: NSLayoutConstraint) -> Component {
        [expression]
    }

    public static func buildExpression(_ expression: Layout) -> Component {
        expression.constraints
    }

    public static func buildBlock(_ components: Component...) -> Component {
        components.flatMap({ $0 })
    }
}
