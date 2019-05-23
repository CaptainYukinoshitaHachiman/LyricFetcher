//
//  Network.swift
//  LyricFetcher
//
//  Created by CaptainYukinoshitaHachiman on 22/05/2019.
//

import Foundation

var urlPrefix: String = ""
fileprivate let session = URLSession.shared

func getLyrics(for id: Int, callback: @escaping (Lyric?) -> Void) {
	guard let lyricURL = URL(string: "\(urlPrefix)/lyric?id=\(id)") else {
		callback(nil)
		return
	}
	session.dataTask(with: lyricURL) { (data, _, _) in
		guard let data = data else {
			callback(nil)
			return
		}
		let lyric = try? JSONDecoder().decode(Lyric.self, from: data)
		callback(lyric)
		}.resume()
}

func getSong(_ name: String, callback: @escaping (SearchResponse?) -> Void) {
	guard let searchURL = URL(string: "\(urlPrefix)/search?keywords=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)") else {
		callback(nil)
		return
	}
	session.dataTask(with: searchURL) { (data, _, _) in
		guard let data = data else {
			callback(nil)
			return
		}
		let searchResponse = try? JSONDecoder().decode(SearchResponse.self, from: data)
		callback(searchResponse)
		}.resume()
}
