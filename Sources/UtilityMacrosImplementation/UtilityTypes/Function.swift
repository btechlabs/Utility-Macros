//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftSyntax

public struct Function {
    let declSyntax: FunctionDeclSyntax

    let accessModifier: String?
    let isStatic: Bool
    let name: String
    let returnType: String?

    init(_ declSyntax: FunctionDeclSyntax) {
        self.declSyntax = declSyntax
        self.accessModifier = declSyntax.accessModifier
        self.isStatic = declSyntax.isStatic
        self.name = declSyntax.name.text
        self.returnType = declSyntax.returnType
    }
}
