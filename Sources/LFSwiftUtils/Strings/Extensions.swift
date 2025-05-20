//
//  Strings.swift
//  LFSwiftUtils
//
//  Created by Luis Finke on 5/18/25.
//

import Foundation

extension String? {
	public var isNilOrWhiteSpace: Bool {
		guard let self = self else {
			return true
		}
		if self.isEmpty {
			return true
		}
		for character in self {
			if !character.isWhitespace && !character.isNewline {
				return false
			}
		}
		return true
	}
	
	public var isNilOrEmpty: Bool {
		guard let self = self else {
			return true
		}
		if self.isEmpty {
			return true
		}
		return false
	}
}

extension String {
	public var isEmptyOrWhiteSpace: Bool {
		if self.isEmpty {
			return true
		}
		for character in self {
			if !character.isWhitespace && !character.isNewline {
				return false
			}
		}
		return true
	}
	
	@available(macOS 13.0, *)
	public func trimmingPrefix(while predicate: (Self.Element) throws -> Bool, limit: Int) rethrows -> Self.SubSequence {
		var count = 0
		return try self.trimmingPrefix(while: { c in
			if count >= limit {
				return false
			}
			count += 1
			return try predicate(c)
		})
	}
	
	public func trimmingSuffix(while predicate: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence {
		var endIndex = self.endIndex
		while endIndex != self.startIndex {
			let nextIndex = self.index(before: endIndex)
			if try predicate(self[nextIndex]) {
				endIndex = nextIndex
			} else {
				break
			}
		}
		return self[..<endIndex]
	}
	
	@available(macOS 13.0, *)
	public func trimming(while predicate: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence {
		return try trimmingPrefix(while: predicate).trimmingSuffix(while: predicate)
	}
	
	@available(macOS 13.0, *)
	public var trimmed: Self.SubSequence {
		return self.trimming(while: { $0.isWhitespace || $0.isNewline })
	}
}

extension Substring? {
	public var isNilOrWhiteSpace: Bool {
		guard let self = self else {
			return true
		}
		if self.isEmpty {
			return true
		}
		for character in self {
			if !character.isWhitespace && !character.isNewline {
				return false
			}
		}
		return true
	}
	
	public var isNilOrEmpty: Bool {
		guard let self = self else {
			return true
		}
		if self.isEmpty {
			return true
		}
		return false
	}
}

extension Substring {
	public var isEmptyOrWhiteSpace: Bool {
		if self.isEmpty {
			return true
		}
		for character in self {
			if !character.isWhitespace && !character.isNewline {
				return false
			}
		}
		return true
	}
	
	@available(macOS 13.0, *)
	public func trimmingPrefix(while predicate: (Self.Element) throws -> Bool, limit: Int) rethrows -> Self.SubSequence {
		var count = 0
		return try self.trimmingPrefix(while: { c in
			if count >= limit {
				return false
			}
			count += 1
			return try predicate(c)
		})
	}
	
	public func trimmingSuffix(while predicate: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence {
		var endIndex = self.endIndex
		while endIndex != self.startIndex {
			let nextIndex = self.index(before: endIndex)
			if try predicate(self[nextIndex]) {
				endIndex = nextIndex
			} else {
				break
			}
		}
		return self[..<endIndex]
	}
	
	@available(macOS 13.0, *)
	public func trimming(while predicate: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence {
		return try trimmingPrefix(while: predicate).trimmingSuffix(while: predicate)
	}
	
	@available(macOS 13.0, *)
	public var trimmed: Self.SubSequence {
		return self.trimming(while: { $0.isWhitespace || $0.isNewline })
	}
}
