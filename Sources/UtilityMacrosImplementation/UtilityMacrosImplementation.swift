import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct UtilityMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MemberWiseInitMacro.self,
        OverridableMacro.self,
        CopyableMacro.self,
    ]
}
