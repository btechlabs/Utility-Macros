//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftSyntax

extension InitializerDeclSyntax {
    public var accessModifier: String? {
        modifiers.first(where: { $0.isAccessModifier })?.name.text
    }

    public var isFailable: Bool {
        optionalMark?.tokenKind == .postfixQuestionMark || optionalMark?.tokenKind == .exclamationMark
    }
}
