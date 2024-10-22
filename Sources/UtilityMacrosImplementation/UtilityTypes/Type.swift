//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftSyntax

public struct `Type` {
    public let accessModifier: String?
    public let name: String
    public let allProperties: [Variable]
    public let allInitializers: [Initializer]
    public let allMethods: [Function]

    public var storedProperties: [Variable] {
        allProperties.filter { !$0.isComputed }
    }

    public var computedProperties: [Variable] {
        allProperties.filter(\.isComputed)
    }

    init (_ declaration: DeclGroupSyntax) {
        self.accessModifier = declaration.accessModifier

        switch declaration.kind {
        case .structDecl:
            self.name = declaration.as(StructDeclSyntax.self)!.name.text
        case .enumDecl:
            self.name = declaration.as(EnumDeclSyntax.self)!.name.text
        case .classDecl:
            self.name = declaration.as(ClassDeclSyntax.self)!.name.text
        case .protocolDecl:
            self.name = declaration.as(ProtocolDeclSyntax.self)!.name.text
        default:
            self.name = ""
        }

        self.allProperties = VariablesFactory.makeVariables(from: declaration.properties)
        self.allInitializers = declaration.initializers.map { Initializer($0) }
        self.allMethods = declaration.methods.map { Function($0) }
    }
}
