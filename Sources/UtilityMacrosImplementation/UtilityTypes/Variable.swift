//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftSyntax

public struct Variable {
    let declSyntax: VariableDeclSyntax
    let bindingIndex: Int

    let accessModifier: String?
    let isStatic: Bool
    let isReadOnly: Bool
    let isComputed: Bool
    let name: String
    let type: String?
    let value: String?

    var isInitialized: Bool { value != nil }

    var isWritable: Bool {
        let isInitializedConstant = isReadOnly && isInitialized
        let isNotWritable = isComputed || isInitializedConstant
        return !isNotWritable
    }
}
