//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftSyntax


extension FunctionDeclSyntax {
    public var accessModifier: String? {
        modifiers.first(where: { $0.isAccessModifier })?.name.text
    }

    public var isStatic: Bool {
        modifiers.contains(where: { $0.name.tokenKind == .keyword(.static) })
    }

    public var returnType: String? {
        signature.returnClause?.type.description.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

