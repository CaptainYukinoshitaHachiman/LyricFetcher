//
//  String+Utilities.swift
//  LyricFetcher
//
//  Created by CaptainYukinoshitaHachiman on 22/05/2019.
//

import Foundation

extension String {
	
	func removingFirst() -> String {
		var removed = self
		removed.removeFirst()
		return removed
	}
	
	func getPathExtension() -> String? {
		guard let dotIndex = lastIndex(of: ".") else { return nil }
		return String(self[dotIndex..<endIndex])
	}
	
	func getFileName() -> String {
		let dotIndex = self.lastIndex(of: ".")
		let slashIndex = self.lastIndex(of: "/")
		if let dotIndex = dotIndex {
			if let slashIndex = slashIndex {
				return String(self[slashIndex..<dotIndex]).removingFirst()
			} else {
				return String(self[startIndex..<dotIndex])
			}
		} else {
			return self
		}
	}
	
}
