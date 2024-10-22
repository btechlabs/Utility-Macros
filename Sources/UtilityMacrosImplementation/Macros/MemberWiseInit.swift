//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


enum InitMacroError: CustomStringConvertible, Error {
    case onlyAppliesToClassesAndStructs
    case allVariablesMustBeTypeAnnotated(variableIdentifier: String)

    var description: String {
        switch self {
        case .onlyAppliesToClassesAndStructs: return "@MemberWiseInitMacro Only applies to classes and structs"
        case let .allVariablesMustBeTypeAnnotated(variableIdentifier): return "@MemberWiseInitMacro variable: \(variableIdentifier) must be type annotated"
        }
    }
}


public struct MemberWiseInitMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let declarationIsClassOrStruct: Bool = declaration.as(ClassDeclSyntax.self) != nil || declaration.as(StructDeclSyntax.self) != nil

        guard declarationIsClassOrStruct else {
            throw InitMacroError.onlyAppliesToClassesAndStructs
        }

        let type = `Type`(declaration)

        let writableProperties = type.allProperties.filter(\.isWritable)

        let params = try writableProperties.map { property in
            guard let type = property.type else {
                throw InitMacroError.allVariablesMustBeTypeAnnotated(variableIdentifier: property.name)
            }

            let typeAnnotatedParam = "\(property.name): \(type)"

            if let value = property.value {
                return "\(typeAnnotatedParam)= \(value)"
            }
            return typeAnnotatedParam

        }.joined(separator: ", ")

        let assignments = writableProperties.map { "self.\($0.name) = \($0.name)" }.joined(separator: "\n")

        let accessModifier: String = if let modifier = type.accessModifier { "\(modifier) " } else { "" }

        let initDecl: DeclSyntax = """
        \(raw: accessModifier)init(\(raw: params)) {
            \(raw: assignments)
        }
        """

        return [initDecl]
    }
}
