//
//  Lyric.swift
//  LyricFetcher
//
//  Created by CaptainYukinoshitaHachiman on 22/05/2019.
//

import Foundation

struct Lyric: Codable {
	struct Lrc: Codable {
		let version: Int
		let lyric: String?
	}
	let lrc: Lrc
	struct Tlyric: Codable {
		let version: Int
		let lyric: String?
	}
	let tlyric: Tlyric
	let code: Int
}
