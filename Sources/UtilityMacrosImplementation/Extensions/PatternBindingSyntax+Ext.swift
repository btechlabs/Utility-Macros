//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension PatternBindingSyntax {
    public var identifier: String {
        pattern.as(IdentifierPatternSyntax.self)!.identifier.text
    }

    public var type: String? {
        typeAnnotation?.as(TypeAnnotationSyntax.self)?.type.description
    }

    public var value: String? {
        initializer?.value.description
    }
}
