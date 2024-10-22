//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct CopyableMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let type = `Type`(declaration)

        let params = type.allProperties.map { "\($0.name): self.\($0.name)" }.joined(separator: ",\n")

        let accessModifier: String = if let modifier = type.accessModifier { "\(modifier) " } else { "" }

        return [
            try ExtensionDeclSyntax("\(raw: accessModifier)extension \(raw: type.name)") {
                """
                func copy() -> \(raw: type.name) {
                    return \(raw: type.name)(
                        \(raw: params)
                    )
                }
                """
            }
        ]
    }
}
