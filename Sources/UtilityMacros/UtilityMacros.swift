// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: named(init))
public macro memberWiseInit() = #externalMacro(module: "UtilityMacrosImplementation", type: "MemberWiseInitMacro")

@attached(extension, names: named(copy))
public macro AutoCopyable() = #externalMacro(module: "UtilityMacrosImplementation", type: "CopyableMacro")
