//  UtilityMacros
//
//  Created by Abdelrhman Elmahdy.
//

import SwiftSyntax

extension VariableDeclSyntax {

    public var isReadOnly: Bool { bindingSpecifier.text == "let" }

    public var accessModifier: String? {
        modifiers.first(where: { $0.isAccessModifier })?.name.text
    }

    public var isComputed: Bool {
        bindings.contains { binding in
            switch binding.accessorBlock?.accessors {
            case .none:
                return false

            case let .some(.accessors(list)):
                return !list.allSatisfy {
                    ["willSet", "didSet"].contains($0.accessorSpecifier.trimmed.text)
                }

            case .getter:
                return true
            }
        }
    }

    public var isStored: Bool {
        !isComputed
    }

    public var isStatic: Bool {
        modifiers.lazy.contains(where: { $0.name.tokenKind == .keyword(.static) }) == true
    }

    public var identifier: TokenSyntax {
        bindings.lazy.compactMap({ $0.pattern.as(IdentifierPatternSyntax.self) }).first!.identifier
    }

    public var typeAnnotation: TypeAnnotationSyntax? {
        bindings.lazy.compactMap(\.typeAnnotation).first
    }

    public var typeAnnotationName: String? {
        if let optionalTypeName = typeAnnotation?.as(TypeAnnotationSyntax.self)?.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name.text {
            return optionalTypeName + "?"
        }

        return typeAnnotation?.as(TypeAnnotationSyntax.self)?.type.as(IdentifierTypeSyntax.self)?.name.text
    }

    public var initializerValue: ExprSyntax? {
        bindings.lazy.compactMap(\.initializer).first?.value
    }

    public var effectSpecifiers: AccessorEffectSpecifiersSyntax? {
        bindings
            .lazy
            .compactMap(\.accessorBlock)
            .compactMap({ accessor in
                switch accessor.accessors {
                case .accessors(let syntax):
                    return syntax.lazy.compactMap(\.effectSpecifiers).first
                case .getter:
                    return nil
                }
            })
            .first
    }

    public var isThrowing: Bool {
        return bindings
            .compactMap(\.accessorBlock)
            .contains(where: { accessor in
                switch accessor.accessors {
                case .accessors(let syntax):
                    return syntax.contains(where: { $0.effectSpecifiers?.throwsSpecifier != nil })
                case .getter:
                    return false
                }
            })
    }

    public var isAsync: Bool {
        return bindings
            .compactMap(\.accessorBlock)
            .contains(where: { accessor in
                switch accessor.accessors {
                case .accessors(let syntax):
                    return syntax.contains(where: { $0.effectSpecifiers?.asyncSpecifier != nil })
                case .getter:
                    return false
                }
            })
    }
}
