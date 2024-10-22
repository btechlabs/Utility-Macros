//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros



struct VariablesFactory {
    static func makeVariables(from variableDecelerations: [VariableDeclSyntax]) -> [Variable] {
        variableDecelerations.flatMap {makeVariables(from: $0)}
    }

    private static func makeVariables(from declaration: VariableDeclSyntax) -> [Variable] {
        let lastType = declaration.bindings.last?.type

        return declaration.bindings.enumerated().map { index, binding in
            Variable(
                declSyntax: declaration,
                bindingIndex: index,
                accessModifier: declaration.accessModifier,
                isStatic: declaration.isStatic,
                isReadOnly: declaration.isReadOnly,
                isComputed: declaration.isComputed,
                name: binding.identifier,
                type: binding.type ?? lastType,
                value: binding.value
            )
        }
    }
}
