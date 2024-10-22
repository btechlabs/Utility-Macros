//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftSyntax

extension DeclGroupSyntax {
    public var properties: [VariableDeclSyntax] {
        memberBlock.members.compactMap({ $0.decl.as(VariableDeclSyntax.self) })
    }

    public var methods: [FunctionDeclSyntax] {
        memberBlock.members.compactMap({ $0.decl.as(FunctionDeclSyntax.self) })
    }

    public var initializers: [InitializerDeclSyntax] {
        memberBlock.members.compactMap({ $0.decl.as(InitializerDeclSyntax.self) })
    }

    public var accessModifier: String? {
        modifiers.first(where: { $0.isAccessModifier })?.name.text
    }
}
