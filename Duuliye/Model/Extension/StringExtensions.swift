//
//  StringExtensions.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 8/5/16.
//  Copyright © 2016 SwifterSwift
//
#if os(macOS)
	import Cocoa
#else
	import UIKit
#endif

// MARK: - Properties
public extension String {
    
   
         func getAcronyms(separator: String = "") -> String
        {
            let acronyms = self.components(separatedBy: " ").map({ String($0.first!) }).joined(separator: separator);
            return acronyms;
        }
    
	
    //Arabic digit to english
     var ArabicDigitsWithEnglish: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
    
	/// SwifterSwift: String decoded from base64 (if applicable).
	///
	///		"SGVsbG8gV29ybGQh".base64Decoded = Optional("Hello World!")
	///
	var base64Decoded: String? {
		// https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
		guard let decodedData = Data(base64Encoded: self) else {
			return ""
		}
        
		return String(data: decodedData, encoding: .utf8)
	}
	
	/// SwifterSwift: String encoded in base64 (if applicable).
	///
	///		"Hello World!".base64Encoded -> Optional("SGVsbG8gV29ybGQh")
	///
	var base64Encoded: String? {
		// https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
		let plainData = data(using: .utf8)
		return plainData?.base64EncodedString()
	}
	
	/// SwifterSwift: Array of characters of a string.
	///
	var charactersArray: [Character] {
		return Array(self)
	}
	
	/// SwifterSwift: CamelCase of string.
	///
	///		"sOme vAriable naMe".camelCased -> "someVariableName"
	///
	var camelCased: String {
		let source = lowercased()
		let first = source[..<source.index(after: source.startIndex)]
		if source.contains(" ") {
			let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
			let camel = connected.replacingOccurrences(of: "\n", with: "")
			let rest = String(camel.dropFirst())
			return first + rest
		}
		let rest = String(source.dropFirst())
		return first + rest
	}
	
	/// SwifterSwift: Check if string contains one or more emojis.
	///
	///		"Hello 😀".containEmoji -> true
	///
	var containEmoji: Bool {
		// http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
		for scalar in unicodeScalars {
			switch scalar.value {
			case 0x3030, 0x00AE, 0x00A9, // Special Characters
			0x1D000...0x1F77F, // Emoticons
			0x2100...0x27BF, // Misc symbols and Dingbats
			0xFE00...0xFE0F, // Variation Selectors
			0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
				return true
			default:
				continue
			}
		}
		return false
	}
	
	/// SwifterSwift: First character of string (if applicable).
	///
	///		"Hello".firstCharacterAsString -> Optional("H")
	///		"".firstCharacterAsString -> nil
	///
	var firstCharacterAsString: String? {
		guard let first = self.first else {
			return nil
		}
		return String(first)
	}
	
	/// SwifterSwift: Check if string contains one or more letters.
	///
	///		"123abc".hasLetters -> true
	///		"123".hasLetters -> false
	///
	var hasLetters: Bool {
		return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
	}
	
	/// SwifterSwift: Check if string contains one or more numbers.
	///
	///		"abcd".hasNumbers -> false
	///		"123abc".hasNumbers -> true
	///
	var hasNumbers: Bool {
		return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
	}
	
	/// SwifterSwift: Check if string contains only letters.
	///
	///		"abc".isAlphabetic -> true
	///		"123abc".isAlphabetic -> false
	///
	var isAlphabetic: Bool {
		let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
		let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
		return hasLetters && !hasNumbers
	}
	
	/// SwifterSwift: Check if string contains at least one letter and one number.
	///
	///		// useful for passwords
	///		"123abc".isAlphaNumeric -> true
	///		"abc".isAlphaNumeric -> false
	///
	var isAlphaNumeric: Bool {
		let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
		let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
		let comps = components(separatedBy: .alphanumerics)
		return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
	}
	
	/// SwifterSwift: Check if string is valid email format.
	///
	///		"john@doe.com".isEmail -> true
	///
	var isEmail: Bool {
		// http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
		return matches(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
	}
	
	/// SwifterSwift: Check if string is a valid URL.
	///
	///		"https://google.com".isValidUrl -> true
	///
	var isValidUrl: Bool {
		return URL(string: self) != nil
	}
	
 
	/// SwifterSwift: Check if string is a valid schemed URL.
	///
	///		"https://google.com".isValidSchemedUrl -> true
	///		"google.com".isValidSchemedUrl -> false
	///
	var isValidSchemedUrl: Bool {
		guard let url = URL(string: self) else {
			return false
		}
		return url.scheme != nil
	}
	
	/// SwifterSwift: Check if string is a valid https URL.
	///
	///		"https://google.com".isValidHttpsUrl -> true
	///
	var isValidHttpsUrl: Bool {
		guard let url = URL(string: self) else {
			return false
		}
		return url.scheme == "https"
	}
	
	/// SwifterSwift: Check if string is a valid http URL.
	///
	///		"http://google.com".isValidHttpUrl -> true
	///
	var isValidHttpUrl: Bool {
		guard let url = URL(string: self) else {
			return false
		}
		return url.scheme == "http"
	}
	
	/// SwifterSwift: Check if string is a valid file URL.
	///
	///		"file://Documents/file.txt".isValidFileUrl -> true
	///
	var isValidFileUrl: Bool {
		return URL(string: self)?.isFileURL ?? false
	}
	
	/// SwifterSwift: Check if string contains only numbers.
	///
	///		"123".isNumeric -> true
	///		"abc".isNumeric -> false
	///
	var isNumeric: Bool {
		let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
		let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
		return  !hasLetters && hasNumbers
	}
	
	/// SwifterSwift: Last character of string (if applicable).
	///
	///		"Hello".lastCharacterAsString -> Optional("o")
	///		"".lastCharacterAsString -> nil
	///
    
	var lastCharacterAsString: String? {
		guard let last = self.last else {
			return nil
		}
		return String(last)
	}
	
	/// SwifterSwift: Latinized string.
	///
	///		"Hèllö Wórld!".latinized -> "Hello World!"
	///
	var latinized: String {
		return folding(options: .diacriticInsensitive, locale: Locale.current)
	}
	
	/// SwifterSwift: Bool value from string (if applicable).
	///
	///		"1".bool -> true
	///		"False".bool -> false
	///		"Hello".bool = nil
	///
	var bool: Bool? {
		let selfLowercased = trimmed.lowercased()
		if selfLowercased == "true" || selfLowercased == "1" {
			return true
		} else if selfLowercased == "false" || selfLowercased == "0" {
			return false
		}
		return nil
	}
	
	/// SwifterSwift: Date object from "yyyy-MM-dd" formatted string.
	///
	///		"2007-06-29".date -> Optional(Date)
	///
	var date: Date? {
		let selfLowercased = trimmed.lowercased()
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.date(from: selfLowercased)
	}
	
	/// SwifterSwift: Date object from "yyyy-MM-dd HH:mm:ss" formatted string.
	///
	///		"2007-06-29 14:23:09".dateTime -> Optional(Date)
	///
	var dateTime: Date? {
		let selfLowercased = trimmed.lowercased()
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return formatter.date(from: selfLowercased)
	}
	
	/// SwifterSwift: Integer value from string (if applicable).
	///
	///		"101".int -> 101
	///
	var int: Int? {
		return Int(self)
	}
	
    var toUrl: URL?
    {
        if self != ""
        {
            return URL.init(string: self)
        }
        else
        {
            return URL.init(string: "")
        }
    }
    
	/// SwifterSwift: Lorem ipsum string of given length.
	///
	/// - Parameter length: number of characters to limit lorem ipsum to (default is 445 - full lorem ipsum).
	/// - Returns: Lorem ipsum dolor sit amet... string.
	 static func loremIpsum(ofLength length: Int = 445) -> String {
		guard length > 0 else { return "" }
		
		// https://www.lipsum.com/
		let loremIpsum = """
		Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
		"""
		if loremIpsum.count > length {
			return String(loremIpsum[loremIpsum.startIndex..<loremIpsum.index(loremIpsum.startIndex, offsetBy: length)])
		}
		return loremIpsum
	}
	
	/// SwifterSwift: URL from string (if applicable).
	///
	///		"https://google.com".url -> URL(string: "https://google.com")
	///		"not url".url -> nil
	///
	var url: URL? {
		return URL(string: self)
	}
	
	/// SwifterSwift: String with no spaces or new lines in beginning and end.
	///
	///		"   hello  \n".trimmed -> "hello"
	///
	var trimmed: String {
		return trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	/// SwifterSwift: Readable string from a URL string.
	///
	///		"it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
	///
	var urlDecoded: String {
		return removingPercentEncoding ?? self
	}
	
	/// SwifterSwift: URL escaped string.
	///
	///		"it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
	///
	var urlEncoded: String {
		return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}
	
	/// SwifterSwift: String without spaces and new lines.
	///
	///		"   \n Swifter   \n  Swift  ".withoutSpacesAndNewLines -> "SwifterSwift"
	///
	var withoutSpacesAndNewLines: String {
		return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
	}
	
}

// MARK: - Methods
public extension String {
	
	/// Float value from string (if applicable).
	///
	/// - Parameter locale: Locale (default is Locale.current)
	/// - Returns: Optional Float value from given string.
	func float(locale: Locale = .current) -> Float? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: self) as? Float
	}
	
	/// Double value from string (if applicable).
	///
	/// - Parameter locale: Locale (default is Locale.current)
	/// - Returns: Optional Double value from given string.
	func double(locale: Locale = .current) -> Double? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: self) as? Double
	}
	
	/// CGFloat value from string (if applicable).
	///
	/// - Parameter locale: Locale (default is Locale.current)
	/// - Returns: Optional CGFloat value from given string.
    func cgFloat(locale: Locale = .current) -> CGFloat? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: self) as? CGFloat
	}
	
	/// SwifterSwift: Array of strings separated by new lines.
	///
	///		"Hello\ntest".lines() -> ["Hello", "test"]
	///
	/// - Returns: Strings separated by new lines.
    func lines() -> [String] {
		var result = [String]()
		enumerateLines { line, _ in
			result.append(line)
		}
		return result
	}
    
    /// SwifterSwift: Returns a localized string, with an optional comment for translators.
    ///
    ///        "Hello world".localized -> Hallo Welt
    ///
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
	
	/// SwifterSwift: The most common character in string.
	///
	///		"This is a test, since e is appearing everywhere e should be the common character".mostCommonCharacter() -> "e"
	///
	/// - Returns: The most common character.
	func mostCommonCharacter() -> Character? {
        let mostCommon = withoutSpacesAndNewLines.reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
        }.max { $0.1 < $1.1 }?.0
        
        return mostCommon
	}
	
	/// SwifterSwift: Array with unicodes for all characters in a string.
	///
	///		"SwifterSwift".unicodeArray -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
	///
	/// - Returns: The unicodes for all characters in a string.
	func unicodeArray() -> [Int] {
		return unicodeScalars.map({ $0.hashValue })
	}
	
	/// SwifterSwift: an array of all words in a string
	///
	///		"Swift is amazing".words() -> ["Swift", "is", "amazing"]
	///
	/// - Returns: The words contained in a string.
	func words() -> [String] {
		// https://stackoverflow.com/questions/42822838
		let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
		let comps = components(separatedBy: chararacterSet)
		return comps.filter { !$0.isEmpty }
	}
	
	/// SwifterSwift: Count of words in a string.
	///
	///		"Swift is amazing".wordsCount() -> 3
	///
	/// - Returns: The count of words contained in a string.
	func wordCount() -> Int {
		// https://stackoverflow.com/questions/42822838
		return words().count
	}
	
	/// SwifterSwift: Safely subscript string with index.
	///
	///		"Hello World!"[3] -> "l"
	///		"Hello World!"[20] -> nil
	///
	/// - Parameter i: index.
	 subscript(safe i: Int) -> Character? {
		guard i >= 0 && i < count else {
			return nil
		}
		return self[index(startIndex, offsetBy: i)]
	}
	
	/// SwifterSwift: Safely subscript string within a half-open range.
	///
	///		"Hello World!"[6..<11] -> "World"
	///		"Hello World!"[21..<110] -> nil
	///
	/// - Parameter range: Half-open range.
	 subscript(safe range: CountableRange<Int>) -> String? {
		guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else {
			return nil
		}
		guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else {
			return nil
		}
		return String(self[lowerIndex..<upperIndex])
	}
	
	/// SwifterSwift: Safely subscript string within a closed range.
	///
	///		"Hello World!"[6...11] -> "World!"
	///		"Hello World!"[21...110] -> nil
	///
	/// - Parameter range: Closed range.
	 subscript(safe range: ClosedRange<Int>) -> String? {
		guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else {
			return nil
		}
		guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else {
			return nil
		}
		return String(self[lowerIndex..<upperIndex])
	}
	
	#if os(iOS) || os(macOS)
	/// SwifterSwift: Copy string to global pasteboard.
	///
	///		"SomeText".copyToPasteboard() // copies "SomeText" to pasteboard
	///
	func copyToPasteboard() {
		#if os(iOS)
			UIPasteboard.general.string = self
		#elseif os(macOS)
			NSPasteboard.general.clearContents()
			NSPasteboard.general.setString(self, forType: .string)
		#endif
	}
	#endif
	
	/// SwifterSwift: Converts string format to CamelCase.
	///
	///		var str = "sOme vaRiabLe Name"
	///		str.camelize()
	///		print(str) // prints "someVariableName"
	///
	mutating func camelize() {
		self = camelCased
	}
	
	/// SwifterSwift: Check if string contains only unique characters.
	///
	func hasUniqueCharacters() -> Bool {
		guard count > 0 else { return false }
		var uniqueChars = Set<String>()
		for char in self {
			if uniqueChars.contains(String(char)) {
				return false
			}
			uniqueChars.insert(String(char))
		}
		return true
	}
	
	/// SwifterSwift: Check if string contains one or more instance of substring.
	///
	///		"Hello World!".contain("O") -> false
	///		"Hello World!".contain("o", caseSensitive: false) -> true
	///
	/// - Parameters:
	///   - string: substring to search for.
	///   - caseSensitive: set true for case sensitive search (default is true).
	/// - Returns: true if string contains one or more instance of substring.
	func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
		if !caseSensitive {
			return range(of: string, options: .caseInsensitive) != nil
		}
		return range(of: string) != nil
	}
	
	/// SwifterSwift: Count of substring in string.
	///
	///		"Hello World!".count(of: "o") -> 2
	///		"Hello World!".count(of: "L", caseSensitive: false) -> 3
	///
	/// - Parameters:
	///   - string: substring to search for.
	///   - caseSensitive: set true for case sensitive search (default is true).
	/// - Returns: count of appearance of substring in string.
	func count(of string: String, caseSensitive: Bool = true) -> Int {
		if !caseSensitive {
			return lowercased().components(separatedBy: string.lowercased()).count - 1
		}
		return components(separatedBy: string).count - 1
	}
	
	/// SwifterSwift: Check if string ends with substring.
	///
	///		"Hello World!".ends(with: "!") -> true
	///		"Hello World!".ends(with: "WoRld!", caseSensitive: false) -> true
	///
	/// - Parameters:
	///   - suffix: substring to search if string ends with.
	///   - caseSensitive: set true for case sensitive search (default is true).
	/// - Returns: true if string ends with substring.
	func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
		if !caseSensitive {
			return lowercased().hasSuffix(suffix.lowercased())
		}
		return hasSuffix(suffix)
	}
	
	/// SwifterSwift: Latinize string.
	///
	///		var str = "Hèllö Wórld!"
	///		str.latinize()
	///		print(str) // prints "Hello World!"
	///
	 mutating func latinize() {
		self = latinized
	}
	
	/// SwifterSwift: Random string of given length.
	///
	///		String.random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
	///
	/// - Parameter length: number of characters in string.
	/// - Returns: random string of given length.
	  func random(ofLength length: Int) -> String {
		guard length > 0 else { return "" }
		let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		var randomString = ""
		for _ in 1...length {
			let randomIndex = arc4random_uniform(UInt32(base.count))
			let randomCharacter = base.charactersArray[Int(randomIndex)]
			randomString.append(randomCharacter)
		}
		return randomString
	}
	
	/// SwifterSwift: Reverse string.
	 mutating func reverse() {
        let chars: [Character] = reversed()
		self = String(chars)
	}
    
    /// SwifterSwift: Sliced string from a start index with length.
    ///
    ///        "Hello World".slicing(from: 6, length: 5) -> "World"
    ///
    /// - Parameters:
    ///   - i: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    /// - Returns: sliced substring of length number of characters (if applicable) (example: "Hello World".slicing(from: 6, length: 5) -> "World")
    func slicing(from i: Int, length: Int) -> String? {
        guard length >= 0, i >= 0, i < count  else {
            return nil
        }
        guard i.advanced(by: length) <= count else {
            return self[safe: i..<count]
        }
        guard length > 0 else {
            return ""
        }
        return self[safe: i..<i.advanced(by: length)]
    }
    
	/// SwifterSwift: Slice given string from a start index with length (if applicable).
	///
	///		var str = "Hello World"
	///		str.slice(from: 6, length: 5)
	///		print(str) // prints "World"
	///
	/// - Parameters:
	///   - i: string index the slicing should start from.
	///   - length: amount of characters to be sliced after given index.
	 mutating func slice(from i: Int, length: Int) {
        
        if let str = self.slicing(from: i, length: length) {
			self = String(str)
		}
	}
	
	/// SwifterSwift: Slice given string from a start index to an end index (if applicable).
	///
	///		var str = "Hello World"
	///		str.slice(from: 6, to: 11)
	///		print(str) // prints "World"
	///
	/// - Parameters:
	///   - start: string index the slicing should start from.
	///   - end: string index the slicing should end at.
	 mutating func slice(from start: Int, to end: Int) {
        guard end >= start else { return }
        
		if let str = self[safe: start..<end] {
			self = str
		}
	}
	
	/// SwifterSwift: Slice given string from a start index (if applicable).
	///
	///		var str = "Hello World"
	///		str.slice(at: 6)
	///		print(str) // prints "World"
	///
	/// - Parameter i: string index the slicing should start from.
	 mutating func slice(at i: Int) {
        guard i < count else { return }
        
        if let str = self[safe: i..<count] {
			self = str
		}
	}
	
	/// SwifterSwift: Check if string starts with substring.
	///
	///		"hello World".starts(with: "h") -> true
	///		"hello World".starts(with: "H", caseSensitive: false) -> true
	///
	/// - Parameters:
	///   - suffix: substring to search if string starts with.
	///   - caseSensitive: set true for case sensitive search (default is true).
	/// - Returns: true if string starts with substring.
	func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
		if !caseSensitive {
			return lowercased().hasPrefix(prefix.lowercased())
		}
		return hasPrefix(prefix)
	}
	
	/// SwifterSwift: Date object from string of date format.
	///
	///		"2017-01-15".date(withFormat: "yyyy-MM-dd") -> Date set to Jan 15, 2017
	///		"not date string".date(withFormat: "yyyy-MM-dd") -> nil
	///
	/// - Parameter format: date format.
	/// - Returns: Date object from string (if applicable).
	func date(withFormat format: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.date(from: self)
	}
	
	/// SwifterSwift: Removes spaces and new lines in beginning and end of string.
	///
	///		var str = "  \n Hello World \n\n\n"
	///		str.trim()
	///		print(str) // prints "Hello World"
	///
	 mutating func trim() {
		self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}
	
	/// SwifterSwift: Truncate string (cut it to a given number of characters).
	///
	///		var str = "This is a very long sentence"
	///		str.truncate(toLength: 14)
	///		print(str) // prints "This is a very..."
	///
	/// - Parameters:
	///   - toLength: maximum number of characters before cutting.
	///   - trailing: string to add at the end of truncated string (default is "...").
	 mutating func truncate(toLength length: Int, trailing: String? = "...") {
		guard length > 0 else {
			return
		}
		if count > length {
			self = self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
		}
	}
	
	/// SwifterSwift: Truncated string (limited to a given number of characters).
	///
	///		"This is a very long sentence".truncated(toLength: 14) -> "This is a very..."
	///		"Short sentence".truncated(toLength: 14) -> "Short sentence"
	///
	/// - Parameters:
	///   - toLength: maximum number of characters before cutting.
	///   - trailing: string to add at the end of truncated string.
	/// - Returns: truncated string (this is an extr...).
	func truncated(toLength length: Int, trailing: String? = "...") -> String {
		guard 1..<count ~= length else { return self }
		return self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
	}
	
	/// SwifterSwift: Convert URL string to readable string.
	///
	///		var str = "it's%20easy%20to%20decode%20strings"
	///		str.urlDecode()
	///		print(str) // prints "it's easy to decode strings"
	///
	 mutating func urlDecode() {
		if let decoded = removingPercentEncoding {
			self = decoded
		}
	}
	
	/// SwifterSwift: Escape string.
	///
	///		var str = "it's easy to encode strings"
	///		str.urlEncode()
	///		print(str) // prints "it's%20easy%20to%20encode%20strings"
	///
	 mutating func urlEncode() {
		if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
			self = encoded
		}
	}
	
	/// SwifterSwift: Verify if string matches the regex pattern.
	///
	/// - Parameter pattern: Pattern to verify.
	/// - Returns: true if string matches the pattern.
	func matches(pattern: String) -> Bool {
		return range(of: pattern,
		             options: String.CompareOptions.regularExpression,
		             range: nil, locale: nil) != nil
	}
	
    /// SwifterSwift: Pad string to fit the length parameter size with another string in the start.
    ///
    ///   "hue".padStart(10) -> "       hue"
    ///   "hue".padStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
     mutating func padStart(_ length: Int, with string: String = " ") {
        self = paddingStart(length, with: string)
    }
    
    /// SwifterSwift: Returns a string by padding to fit the length parameter size with another string in the start.
    ///
    ///   "hue".paddingStart(10) -> "       hue"
    ///   "hue".paddingStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the start.
    func paddingStart(_ length: Int, with string: String = " ") -> String {
        
        guard count < length else { return self }
        
        let padLength = length - count
        if padLength < string.count {
            return string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)] + self
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)] + self
        }
    }
    
    /// SwifterSwift: Pad string to fit the length parameter size with another string in the start.
    ///
    ///   "hue".padEnd(10) -> "hue       "
    ///   "hue".padEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
     mutating func padEnd(_ length: Int, with string: String = " ") {
        self = paddingEnd(length, with: string)
    }
    
    /// SwifterSwift: Returns a string by padding to fit the length parameter size with another string in the end.
    ///
    ///   "hue".paddingEnd(10) -> "hue       "
    ///   "hue".paddingEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the end.
    func paddingEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }
        
        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return self + padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }
    
    func getHashTags()->[String]{
        var hashtags = [String]()
        let regex = try? NSRegularExpression(pattern: "(#[A-Za-z0-9]*)", options: [])
        if let regex = regex{
        let matches = regex.matches(in: self, options:[], range:NSMakeRange(0, self.count))
            for match in matches {
                //print("match = \(match.range)")
                hashtags.append(NSString(string: self).substring(with: NSRange(location:match.range.location + 1,   length:match.range.length - 1)))
            }
        }
        return hashtags
    }

}

// MARK: - Operators
public extension String {
	
	/// SwifterSwift: Repeat string multiple times.
	///
	///		'bar' * 3 -> "barbarbar"
	///
	/// - Parameters:
	///   - lhs: string to repeat.
	///   - rhs: number of times to repeat character.
	/// - Returns: new string with given string repeated n times.
	 static func * (lhs: String, rhs: Int) -> String {
		guard rhs > 0 else {
			return ""
		}
		return String(repeating: lhs, count: rhs)
	}
	
	/// SwifterSwift: Repeat string multiple times.
	///
	///		3 * 'bar' -> "barbarbar"
	///
	/// - Parameters:
	///   - lhs: number of times to repeat character.
	///   - rhs: string to repeat.
	/// - Returns: new string with given string repeated n times.
	 static func * (lhs: Int, rhs: String) -> String {
		guard lhs > 0 else {
			return ""
		}
		return String(repeating: rhs, count: lhs)
	}
	
}

// MARK: - Initializers
public extension String {
	
	/// SwifterSwift: Create a new string from a base64 string (if applicable).
	///
	///		String(base64: "SGVsbG8gV29ybGQh") = "Hello World!"
	///		String(base64: "hello") = nil
	///
	/// - Parameter base64: base64 string.
	 init?(base64: String) {
		guard let str = base64.base64Decoded else {
			return nil
		}
		self.init(str)
	}
}


// MARK: - NSAttributedString extensions
public extension String {
	
	#if !os(tvOS) && !os(watchOS)
	/// SwifterSwift: Bold string.
	///
	var bold: NSAttributedString {
		#if os(macOS)
			return NSMutableAttributedString(string: self, attributes: [.font: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)])
		#else
			return NSMutableAttributedString(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
		#endif
	}
	#endif
	
	/// SwifterSwift: Underlined string
	///
	var underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
	}
	
	/// SwifterSwift: Strikethrough string.
	///
	var strikethrough: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
	}
	
	#if os(iOS)
	/// SwifterSwift: Italic string.
	///
	var italic: NSAttributedString {
		return NSMutableAttributedString(string: self, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
	}
	#endif
	
	#if os(macOS)
	/// SwifterSwift: Add color to string.
	///
	/// - Parameter color: text color.
	/// - Returns: a NSAttributedString versions of string colored with given color.
	func colored(with color: NSColor) -> NSAttributedString {
	return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
	}
	#else
	/// SwifterSwift: Add color to string.
	///
	/// - Parameter color: text color.
	/// - Returns: a NSAttributedString versions of string colored with given color.
	func colored(with color: UIColor) -> NSAttributedString {
		return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
	}
	#endif
	
}

// MARK: - NSString extensions
public extension String {
	
	/// SwifterSwift: NSString from a string.
	///
    var nsString: NSString {
		return NSString(string: self)
	}
	
	/// SwifterSwift: NSString lastPathComponent.
	///
	var lastPathComponent: String {
		return (self as NSString).lastPathComponent
	}
	
	/// SwifterSwift: NSString pathExtension.
	///
	var pathExtension: String {
		return (self as NSString).pathExtension
	}
	
	/// SwifterSwift: NSString deletingLastPathComponent.
	///
	var deletingLastPathComponent: String {
		return (self as NSString).deletingLastPathComponent
	}
	
	/// SwifterSwift: NSString deletingPathExtension.
	///
	var deletingPathExtension: String {
		return (self as NSString).deletingPathExtension
	}
	
	/// SwifterSwift: NSString pathComponents.
	///
	var pathComponents: [String] {
		return (self as NSString).pathComponents
	}
	
	/// SwifterSwift: NSString appendingPathComponent(str: String)
	///
	/// - Parameter str: the path component to append to the receiver.
	/// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
	func appendingPathComponent(_ str: String) -> String {
		return (self as NSString).appendingPathComponent(str)
	}
	
	/// SwifterSwift: NSString appendingPathExtension(str: String)
	///
	/// - Parameter str: The extension to append to the receiver.
	/// - Returns: a new string made by appending to the receiver an extension separator followed by ext (if applicable).
	func appendingPathExtension(_ str: String) -> String? {
		return (self as NSString).appendingPathExtension(str)
	}
	
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
}

extension NSMutableAttributedString
{
    func convertFontTo(font: UIFont)
    {
        //let range = NSMakeRange(0, 0)
        
        //        while (NSMaxRange(range) < length)
        //        {
        //            let attributes1 = attributes(at: NSMaxRange(range), effectiveRange: &range)
        //            if let oldFont = attributes1[NSAttributedStringKey.font]
        //            {
        addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, self.length))
        //            }
        //        }
    }
}
extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
extension Data
{
    var html2AttributedString: NSAttributedString?
    {
        do
        {
            let str = try NSAttributedString.init(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            let desc = NSMutableAttributedString(attributedString: str)
            desc.convertFontTo(font: UIFont.init(name: "Avenir Next", size: 15)!)
            return desc
        }
        catch {
            //print("error:", error)
            return  nil
        }
    }
}



extension Float {
    var cleanDummyFloat: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
extension Double {
    func toInt() -> Int? {
        if self >= Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
