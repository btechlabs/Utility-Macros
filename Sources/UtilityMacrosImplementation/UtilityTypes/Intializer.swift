//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftSyntax


public struct Initializer {
    let declSyntax: InitializerDeclSyntax

    let accessModifier: String?
    let isFailable: Bool

    init(_ declSyntax: InitializerDeclSyntax) {
        self.declSyntax = declSyntax
        self.accessModifier = declSyntax.accessModifier
        self.isFailable = declSyntax.isFailable
    }
}
