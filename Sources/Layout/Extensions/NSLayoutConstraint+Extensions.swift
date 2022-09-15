public extension NSLayoutConstraint {
    @discardableResult
    static func activate(@ConstraintBuilder builder: () -> [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        let constraints = builder()
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
