//
//  Strings.swift
//  LFSwiftUtils
//
//  Created by Luis Finke on 5/18/25.
//

extension String? {
	var isNullOrWhiteSpace: Bool {
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
}

extension String {
	var isEmptyOrWhiteSpace: Bool {
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
	
	func trimmingSuffix(while predicate: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence {
		var endIndex = self.endIndex
		repeat {
			let nextIndex = self.index(before: endIndex)
			if try predicate(self[nextIndex]) {
				endIndex = nextIndex
			}
		} while endIndex != self.startIndex
		return self[..<endIndex]
	}
}

extension Substring {
	var isEmptyOrWhiteSpace: Bool {
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
	
	func trimmingSuffix(while predicate: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence {
		var endIndex = self.endIndex
		repeat {
			let nextIndex = self.index(before: endIndex)
			if try predicate(self[nextIndex]) {
				endIndex = nextIndex
			}
		} while endIndex != self.startIndex
		return self[..<endIndex]
	}
}
