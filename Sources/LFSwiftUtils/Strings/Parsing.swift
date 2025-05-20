//
//  StringParsing.swift
//  LFSwiftUtils
//
//  Created by Luis Finke on 5/18/25.
//

extension LFUtils {
	@available(macOS 13.0, *)
	public typealias AnyLineWhereHandler = (_ line: Substring, _ lineEnd: Regex<Substring>.Match?) throws -> Bool
	
	@available(macOS 13.0, *)
	public typealias AnyLineWhereAsyncHandler = (_ line: Substring, _ lineEnd: Regex<Substring>.Match?) async throws -> Bool
	
	@available(macOS 13.0, *)
	public typealias ForEachLineHandler = (_ line: Substring, _ lineEnd: Regex<Substring>.Match?) throws -> Void
	
	@available(macOS 13.0, *)
	public typealias ForEachLineAsyncHandler = (_ line: Substring, _ lineEnd: Regex<Substring>.Match?) async throws -> Void
	
	@available(macOS 13.0, *)
	public static func anyLine(in string: String, where handler: AnyLineWhereHandler) rethrows -> Bool {
		return try anyLine(in:string[...], where:handler)
	}
	
	@available(macOS 13.0, *)
	public static func anyLine(in string: String, where handler: AnyLineWhereAsyncHandler) async rethrows -> Bool {
		return try await anyLine(in:string[...], where:handler)
	}
	
	@available(macOS 13.0, *)
	public static func forEachLine(in string: String, _ handler: ForEachLineHandler) rethrows {
		try forEachLine(in:string[...], handler)
	}
	
	@available(macOS 13.0, *)
	public static func forEachLine(in string: String, _ handler: ForEachLineAsyncHandler) async rethrows {
		try await forEachLine(in:string[...], handler)
	}
	
	@available(macOS 13.0, *)
	public static func anyLine(in string: Substring, where handler: AnyLineWhereHandler) rethrows -> Bool {
		var startIndex = string.startIndex
		while startIndex != string.endIndex {
			let newLineMatch = string[startIndex...].firstMatch(of: /\R/)
			let line = string[startIndex..<(newLineMatch?.startIndex ?? string.endIndex)]
			if try handler(line,newLineMatch) {
				return true
			}
			startIndex = newLineMatch?.endIndex ?? string.endIndex
		}
		return false
	}
	
	@available(macOS 13.0, *)
	public static func anyLine(in string: Substring, where handler: AnyLineWhereAsyncHandler) async rethrows -> Bool {
		var startIndex = string.startIndex
		while startIndex != string.endIndex {
			let newLineMatch = string[startIndex...].firstMatch(of: /\R/)
			let line = string[startIndex..<(newLineMatch?.startIndex ?? string.endIndex)]
			if try await handler(line,newLineMatch) {
				return true
			}
			startIndex = newLineMatch?.endIndex ?? string.endIndex
		}
		return false
	}
	
	@available(macOS 13.0, *)
	public static func forEachLine(in string: Substring, _ handler: ForEachLineHandler) rethrows {
		var startIndex = string.startIndex
		while startIndex != string.endIndex {
			let newLineMatch = string[startIndex...].firstMatch(of: /\R/)
			let line = string[startIndex..<(newLineMatch?.startIndex ?? string.endIndex)]
			try handler(line,newLineMatch)
			startIndex = newLineMatch?.endIndex ?? string.endIndex
		}
	}
	
	@available(macOS 13.0, *)
	public static func forEachLine(in string: Substring, _ handler: ForEachLineAsyncHandler) async rethrows {
		var startIndex = string.startIndex
		while startIndex != string.endIndex {
			let newLineMatch = string[startIndex...].firstMatch(of: /\R/)
			let line = string[startIndex..<(newLineMatch?.startIndex ?? string.endIndex)]
			try await handler(line,newLineMatch)
			startIndex = newLineMatch?.endIndex ?? string.endIndex
		}
	}
}
