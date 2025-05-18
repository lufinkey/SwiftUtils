//
//  StringParsing.swift
//  LFSwiftUtils
//
//  Created by Luis Finke on 5/18/25.
//

extension String {
	@available(macOS 13.0, *)
	public typealias AnyLineWhereHandler = (_ line: Substring, _ lineEnd: Regex<Substring>.Match?) throws -> Bool
	
	@available(macOS 13.0, *)
	public typealias AnyLineWhereAsyncHandler = (_ line: Substring, _ lineEnd: Regex<Substring>.Match?) async throws -> Bool
	
	@available(macOS 13.0, *)
	public typealias ForEachLineHandler = (_ line: Substring, _ lineEnd: Regex<Substring>.Match?) throws -> Void
	
	@available(macOS 13.0, *)
	public typealias ForEachLineAsyncHandler = (_ line: Substring, _ lineEnd: Regex<Substring>.Match?) async throws -> Void
	
	@available(macOS 13.0, *)
	public func anyLine(where handler: AnyLineWhereHandler) rethrows -> Bool {
		return try self[...].anyLine(where: handler)
	}
	
	@available(macOS 13.0, *)
	public func anyLine(where handler: AnyLineWhereAsyncHandler) async rethrows -> Bool {
		return try await self[...].anyLine(where: handler)
	}
	
	@available(macOS 13.0, *)
	public func forEachLine(where handler: ForEachLineHandler) rethrows {
		try self[...].forEachLine(handler)
	}
	
	@available(macOS 13.0, *)
	public func anyLine(where handler: ForEachLineAsyncHandler) async rethrows {
		try await self[...].forEachLine(handler)
	}
}

extension Substring {
	@available(macOS 13.0, *)
	public func anyLine(where handler: String.AnyLineWhereHandler) rethrows -> Bool {
		var startIndex = self.startIndex
		while startIndex != self.endIndex {
			let newLineMatch = self[startIndex...].firstMatch(of: /\r\n|\n|\r/)
			let line = self[startIndex..<(newLineMatch?.startIndex ?? self.endIndex)]
			if try handler(line,newLineMatch) {
				return true
			}
			startIndex = newLineMatch?.endIndex ?? self.endIndex
		}
		return false
	}
	
	@available(macOS 13.0, *)
	public func anyLine(where handler: String.AnyLineWhereAsyncHandler) async rethrows -> Bool {
		var startIndex = self.startIndex
		while startIndex != self.endIndex {
			let newLineMatch = self[startIndex...].firstMatch(of: /\r\n|\n|\r/)
			let line = self[startIndex..<(newLineMatch?.startIndex ?? self.endIndex)]
			if try await handler(line,newLineMatch) {
				return true
			}
			startIndex = newLineMatch?.endIndex ?? self.endIndex
		}
		return false
	}
	
	@available(macOS 13.0, *)
	public func forEachLine(_ handler: String.ForEachLineHandler) rethrows {
		var startIndex = self.startIndex
		while startIndex != self.endIndex {
			let newLineMatch = self[startIndex...].firstMatch(of: /\r\n|\n|\r/)
			let line = self[startIndex..<(newLineMatch?.startIndex ?? self.endIndex)]
			try handler(line,newLineMatch)
			startIndex = newLineMatch?.endIndex ?? self.endIndex
		}
	}
	
	@available(macOS 13.0, *)
	public func forEachLine(_ handler: String.ForEachLineAsyncHandler) async rethrows {
		var startIndex = self.startIndex
		while startIndex != self.endIndex {
			let newLineMatch = self[startIndex...].firstMatch(of: /\r\n|\n|\r/)
			let line = self[startIndex..<(newLineMatch?.startIndex ?? self.endIndex)]
			try await handler(line,newLineMatch)
			startIndex = newLineMatch?.endIndex ?? self.endIndex
		}
	}
}
