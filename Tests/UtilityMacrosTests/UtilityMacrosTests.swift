import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(UtilityMacrosImplementation)
import UtilityMacrosImplementation

let testMacros: [String: Macro.Type] = [
    "memberWiseInit": MemberWiseInitMacro.self,
    "overridable": OverridableMacro.self,
    "copyable": CopyableMacro.self
]
#endif

final class UtilityMacrosTests: XCTestCase {

    func testInitMacro() throws {
        #if canImport(UtilityMacrosImplementation)
        assertMacroExpansion(
            """
            @memberWiseInit
            public class Test {
                var test1: Int
                var test2: Bool? = false
                var test3: String = "str"
                let test4: Float = 0
                let test5 = ""
                var test6: Test = Test()
                var test7, test8: Test
            }
            """,
            expandedSource: """
            public class Test {
                var test1: Int
                var test2: Bool? = false
                var test3: String = "str"
                let test4: Float = 0
                let test5 = ""
                var test6: Test = Test()
                var test7, test8: Test

                public init(test1: Int, test2: Bool? = false, test3: String = "str", test6: Test = Test(), test7: Test, test8: Test) {
                    self.test1 = test1
                    self.test2 = test2
                    self.test3 = test3
                    self.test6 = test6
                    self.test7 = test7
                    self.test8 = test8
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testInitMacroWithMultipleBindings() throws {
        #if canImport(UtilityMacrosImplementation)
        assertMacroExpansion(
            """
            @memberWiseInit
            struct Test {
                public let x1, y1: String
                let x2: Bool, y2: String
                let x3: Bool, y3: String = ""
                let x4: Bool = false, y4: String = ""
            }
            """,
            expandedSource: """
            struct Test {
                public let x1, y1: String
                let x2: Bool, y2: String
                let x3: Bool, y3: String = ""
                let x4: Bool = false, y4: String = ""

                init(x1: String, y1: String, x2: Bool, y2: String, x3: Bool) {
                    self.x1 = x1
                    self.y1 = y1
                    self.x2 = x2
                    self.y2 = y2
                    self.x3 = x3
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testInitMacroOnEnum() throws {
        #if canImport(UtilityMacrosImplementation)
        assertMacroExpansion(
            """
            @memberWiseInit
            enum Test {
                case test
            }
            """,
            expandedSource: """
            enum Test {
                case test
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "@MemberWiseInitMacro Only applies to classes and structs", line: 1, column: 1),
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }


    func testOverridableMacro() throws {
        #if canImport(UtilityMacrosImplementation)
        assertMacroExpansion(
            """
            @overridable
            class Test {
                var layoutAxis: NSLayoutConstraint.Axis?
                var animation: AnimationType?
            }
            """,
            expandedSource: """
            class Test {
                var layoutAxis: NSLayoutConstraint.Axis?
                var animation: AnimationType?
            }

            extension Test: Overridable {
                static func override(_ overridden: inout Self, with overriding: Self?) {
                    if let overridingProperty = overriding?.layoutAxis {
                    overridden.layoutAxis = overridingProperty
                    }

                    if let overridingProperty = overriding?.animation {
                        overridden.animation = overridingProperty
                    }
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testCopyableMacro() throws {
        #if canImport(UtilityMacrosImplementation)
        assertMacroExpansion(
            """
            @copyable
            public class Person {
                let name: String
                let age: Int
                let primaryAddress: Address
                let secondaryAddress: Address?
            }
            """,
            expandedSource: """
            public class Person {
                let name: String
                let age: Int
                let primaryAddress: Address
                let secondaryAddress: Address?
            }

            public extension Person {
                func copy() -> Person {
                    return Person(
                        name: self.name,
                        age: self.age,
                        primaryAddress: self.primaryAddress,
                        secondaryAddress: self.secondaryAddress
                    )
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
