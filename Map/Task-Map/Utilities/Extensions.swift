//
//  Extensions.swift
//  Task-Map
//
//  Created by Christi John on 09/07/2020.
//  Copyright © 2020 Christi John. All rights reserved.
//

import Foundation

extension Dictionary {
	func percentEncoded() -> Data? {
		return map { key, value in
			let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
			let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
			return escapedKey + "=" + escapedValue
		}
		.joined(separator: "&")
		.data(using: .utf8)
	}
}

extension CharacterSet {
	static let urlQueryValueAllowed: CharacterSet = {
		let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
		let subDelimitersToEncode = "!$&'()*+,;="
		
		var allowed = CharacterSet.urlQueryAllowed
		allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
		return allowed
	}()
}
