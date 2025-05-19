//
//  Regex.swift
//  LFSwiftUtils
//
//  Created by Luis Finke on 5/18/25.
//

import Foundation
import RegexBuilder

extension LFUtils {
	@available(macOS 13.0, *)
	public static func unescapedCharacterRegex(for char: Character) -> Regex<(Substring, Substring)> {
		// (?:^|(?:[^\\"]+))(?:\\\\)*(")
		return Regex {
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
	}
	
	@available(macOS 13.0, *)
	public static func unescapedCharacterClassRegex(for charClass: CharacterClass) -> Regex<(Substring, Substring)> {
		// (?:^|(?:[^\\"]+))(?:\\\\)*(")
		return Regex {
			// non-capturing group: ^ or [^\\char]+
			ChoiceOf {
				Anchor.startOfLine
				OneOrMore {
					CharacterClass.anyOf("\\").union(charClass).inverted
				}
			}
			// then zero or more pairs of backslashes (escaped backslashes)
			ZeroOrMore {
				"\\\\" // matches literal two backslashes
			}
			// capture the dynamic character
			Capture {
				charClass
			}
		}
	}
	
	@available(macOS 13.0, *)
	public static func escapingUnescaped(char: Character, in string: String) -> String {
		let regex = unescapedCharacterRegex(for:char)
		return self.escapingGroup1(from:regex, in:string)
	}
	
	@available(macOS 13.0, *)
	public static func escapingUnescaped(char: CharacterClass, in string: String) -> String {
		let regex = unescapedCharacterClassRegex(for:char)
		return self.escapingGroup1(from:regex, in:string)
	}
	
	@available(macOS 13.0, *)
	private static func escapingGroup1(from regex: Regex<(Substring, Substring)>, in string: String) -> String {
		var newStr = ""
		var index = string.startIndex
		while index != string.endIndex {
			if let match = string[index...].firstMatch(of: regex) {
				newStr += "\(string[index..<match.1.startIndex])\\\(string[match.1.startIndex..<match.range.upperBound])"
				index = match.range.upperBound
			} else {
				if index == string.startIndex {
					return string
				}
				newStr += string[index...]
				return newStr
			}
		}
		if index == string.startIndex {
			return string
		}
		newStr += string[index...]
		return newStr
	}
	
	private static let jsonDecoder = JSONDecoder()
	
	@available(macOS 13.0, *)
	public static func unescaping(string: String) throws -> String {
		let data = Data("\"\(LFUtils.escapingUnescaped(char:"\"", in:string))\"".utf8)
		return try Self.jsonDecoder.decode(String.self, from:data)
	}
}
