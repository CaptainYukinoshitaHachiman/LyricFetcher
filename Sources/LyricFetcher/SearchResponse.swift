//
//  SearchResponse.swift
//  LyricFetcher
//
//  Created by CaptainYukinoshitaHachiman on 22/05/2019.
//

import Foundation

struct SearchResponse: Codable {
	struct Result: Codable {
		struct Songs: Codable {
			let id: Int
		}
		let songs: [Songs]
	}
	let result: Result
	let code: Int
}
