extension NSDirectionalEdgeInsets: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
  public init(integerLiteral value: Int) {
    self.init(
      top: Double(value),
      leading: Double(value),
      bottom: Double(value),
      trailing: Double(value)
    )
  }

  public init(floatLiteral value: Double) {
    self.init(
      top: value,
      leading: value,
      bottom: value,
      trailing: value
    )
  }
}
