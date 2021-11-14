#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public extension NSDirectionalRectEdge {
    static let vertical: Self = [.top, .bottom]

    static let horizontal: Self = [.leading, .trailing]
}
