//
//  Regex.swift
//  LFSwiftUtils
//
//  Created by Luis Finke on 5/18/25.
//

import RegexBuilder

extension String {
	@available(macOS 13.0, *)
	public func escapingUnescaped(char: Character) -> Self {
		// (?:^|(?:[^\\"]+))(?:\\\\)*(")
		let regex = Regex {
			// non-capturing group: ^ or [^\\char]+
			ChoiceOf {
				Anchor.startOfLine
				OneOrMore {
					CharacterClass.anyOf("\\\(char)").inverted
				}
			}
			// then zero or more pairs of backslashes (escaped backslashes)
			ZeroOrMore {
				"\\\\" // matches literal two backslashes
			}
			// capture the dynamic character
			Capture {
				char
			}
		}
		return self.escapingGroup1(in: regex)
	}
	
	@available(macOS 13.0, *)
	public func escapingUnescaped(char: CharacterClass) -> Self {
		// (?:^|(?:[^\\"]+))(?:\\\\)*(")
		let regex = Regex {
			// non-capturing group: ^ or [^\\char]+
			ChoiceOf {
				Anchor.startOfLine
				OneOrMore {
					CharacterClass.anyOf("\\").union(char).inverted
				}
			}
			// then zero or more pairs of backslashes (escaped backslashes)
			ZeroOrMore {
				"\\\\" // matches literal two backslashes
			}
			// capture the dynamic character
			Capture {
				char
			}
		}
		return self.escapingGroup1(in: regex)
	}
	
	@available(macOS 13.0, *)
	private func escapingGroup1(in regex: Regex<(Substring, Substring)>) -> Self {
		// create new string
		var newStr = ""
		var index = self.startIndex
		while index != self.endIndex {
			if let match = self[index...].firstMatch(of: regex) {
				newStr += "\(self[index..<match.1.startIndex])\\\(self[match.1.startIndex..<match.range.upperBound])"
				index = match.range.upperBound
			} else {
				if index == self.startIndex {
					return self
				}
				newStr += self[index...]
				return newStr
			}
		}
		if index == self.startIndex {
			return self
		}
		newStr += self[index...]
		return newStr
	}
}
