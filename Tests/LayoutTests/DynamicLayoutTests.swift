@_spi(Testing) import Layout
import XCTest

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

final class DynamicLayoutTests: XCTestCase {
    #if canImport(UIKit)
    lazy var parent = UIView()

    lazy var view: UIView = {
        let view = UIView()
        parent.addSubview(view)
        return view
    }()

    lazy var otherView: UIView = {
        let view = UIView()
        parent.addSubview(view)
        return view
    }()
    #elseif canImport(AppKit)
    lazy var parent = NSView()

    lazy var view: NSView = {
        let view = NSView()
        parent.addSubview(view)
        return view
    }()

    lazy var otherView: NSView = {
        let view = NSView()
        parent.addSubview(view)
        return view
    }()
    #endif

    private var sut: DynamicLayout<Int>!

    override func setUp() {
        super.setUp()
        sut = .init()
    }

    func testBasic() {
        let layout = view.layout.alignEdges()
        var x = 0

        sut.configure { ctx in
            ctx.constraints {
                layout
            }

            ctx.action {
                x += 1
            }
        }

        XCTAssertTrue(sut.activeConstraints.isEmpty)
        sut.update(state: 0)
        XCTAssertEqual(x, 1)
        AssertConstraintsEqual(sut.activeConstraints, layout.constraints)
        sut.update(state: 0)
        XCTAssertEqual(x, 2)
    }

    func testWhen() {
        let a = view.layout.alignEdges()
        let b = view.layout.containEdges(.all)

        var x = 0

        sut.configure { ctx in
            ctx.when(.greaterThanOrEqual(to: 10)) {
                ctx.constraints {
                    a
                }

                ctx.action {
                    x = $0
                }
            } otherwise: {
                ctx.constraints {
                    b
                }

                ctx.action {
                    x = $0 * 2
                }
            }
        }

        sut.update(state: 1)
        AssertConstraintsEqual(sut.activeConstraints, b.constraints)
        XCTAssertEqual(x, 2)

        sut.update(state: 10)
        AssertConstraintsEqual(sut.activeConstraints, a.constraints)
        XCTAssertEqual(x, 10)
    }

    func testNestedWhen() {
        let a = view.layout.alignEdges()
        let b = view.layout.containEdges(.all)

        var x = 0

        sut.configure { ctx in
            ctx.when(.greaterThanOrEqual(to: 10)) {
                ctx.constraints {
                    a
                }

                ctx.action {
                    x = $0
                }

                ctx.when(.greaterThanOrEqual(to: 100)) {
                    ctx.constraints {
                        b
                    }

                    ctx.action {
                        x = $0 + 1
                    }
                }
            }
        }

        sut.update(state: 10)
        AssertConstraintsEqual(sut.activeConstraints, a.constraints)
        XCTAssertEqual(x, 10)

        sut.update(state: 100)
        AssertConstraintsEqual(sut.activeConstraints, a.constraints + b.constraints)
        XCTAssertEqual(x, 101)

        sut.update(state: 0)
        XCTAssertTrue(sut.activeConstraints.isEmpty)
        XCTAssertEqual(x, 101)
    }
}

extension DynamicLayout.Predicate where State: Comparable {
    static func greaterThanOrEqual(to value: State) -> Self {
        .init({ $0 >= value })
    }
}
