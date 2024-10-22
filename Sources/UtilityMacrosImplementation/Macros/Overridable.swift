//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct OverridableMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let type = `Type`(declaration)

        let overrides = type.allProperties
            .map {
                """
                if let overridingProperty = overriding?.\($0.name) {
                    overridden.\($0.name) = overridingProperty
                }
                """
            }
            .joined(separator: "\n\n")

        let accessModifier: String = if let modifier = type.accessModifier { "\(modifier) " } else { "" }

        return [
            try ExtensionDeclSyntax("\(raw: accessModifier)extension \(raw: type.name): Overridable") {
                """
                static func override(_ overridden: inout Self, with overriding: Self?) {
                    \(raw: overrides)
                }
                """
            }
        ]
    }
}
