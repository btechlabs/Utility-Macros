//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftSyntax

extension DeclModifierSyntax {
    var isAccessModifier: Bool {
        switch name.tokenKind {
        case .keyword(.public), .keyword(.private), .keyword(.internal), .keyword(.fileprivate):
            return true
        default:
            return false
        }
    }
}
