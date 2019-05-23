import Foundation
import Shell
import Commander

let fileManager = FileManager.default

if #available(OSX 10.11, *) {
	command(
		Option<String>("serverPrefix", default: "http://localhost:3000"),
		Option<String>("path", default: fileManager.currentDirectoryPath)
	) { serverPrefix, rootPath in
		urlPrefix = serverPrefix
		let apiFileURL = URL(fileURLWithPath: "app.js", relativeTo: URL(fileURLWithPath: "\(rootPath)", isDirectory: true))
		let apiFileShellPath = "'\(apiFileURL.path)'"
		let a = shell.node(apiFileShellPath, "> /Users/captainyukinoshitahachiman/lyricFetcher.log", "&").stdout
		
		let downloadQueue = DispatchQueue.global()
		
		func getSongNameForFileAt(_ path: String) -> String? {
			// See [SR-10753](https://bugs.swift.org/browse/SR-10753)
			let shellPath = "'\(rootPath)/\(path)'"
			let output = shell.exiftool(shellPath,"-title").stdout
			let endIndex = output.endIndex
			guard let colonIndex = output.firstIndex(of: ":") else { return nil }
			let preString = String(output[colonIndex..<endIndex])
			guard let newlineIndex = preString.firstIndex(of: "\n") else { return nil }
			let startIndex = preString.startIndex
			let title = preString[startIndex..<newlineIndex]
			return String(title).removingFirst().removingFirst()
		}
		
		func addSongQuery(title: String, callback: @escaping (SearchResponse?) -> Void, depth: Int = 0) {
			if depth >= 8 {
				callback(nil)
				return
			}
			downloadQueue.async {
				getSong(title, callback: { (response) in
					if let response = response {
						callback(response)
					} else {
						addSongQuery(title: title, callback: callback, depth: depth + 1)
					}
				})
			}
		}
		
		func addLyricFetchingForSongWithID(_ id: Int, callback: @escaping (String?) -> Void, depth: Int = 0) {
			if depth >= 8 {
				callback(nil)
				return
			}
			downloadQueue.async {
				getLyrics(for: id, callback: { (lyric) in
					if let lyric = lyric {
						let originalLyric = lyric.lrc.lyric ?? ""
						let translatedLyric = lyric.tlyric.lyric ?? ""
						let lrcString = "\(originalLyric)\n\(translatedLyric)"
						callback(lrcString)
					} else {
						addLyricFetchingForSongWithID(id, callback: callback, depth: depth + 1)
					}
				})
			}
		}
		
		guard let enumerator = fileManager.enumerator(atPath: rootPath) else { fatalError() }
		let enumerated = enumerator.enumerated()
		let paths = enumerated.map { (_, path) in
			return path as! String
		}
		
		let filePaths = paths.filter { (path) -> Bool in
			guard let fileExtension = path.getPathExtension()?.removingFirst() else { return false }
			return [
				"mp3",
				"flac",
				"aiff",
				"wav"
				].contains(fileExtension)
		}
		
		var count = 0
		
		print("Fetching...")
		
		filePaths.forEach { (filePath) in
			// Since the path has extension due to line 47-55, it cannot be nil
			let title = getSongNameForFileAt(filePath) ?? filePath.getFileName()
			print("Starting fetcing \(title) at \(filePath).")
			downloadQueue.async {
				addSongQuery(title: title, callback: { (response) in
					if let id = response?.result.songs.first?.id {
						addLyricFetchingForSongWithID(id, callback: { (lyric) in
							if let lyric = lyric {
								let songURL = URL(fileURLWithPath: filePath, relativeTo: URL(fileURLWithPath: rootPath))
								let lyricURL = songURL.deletingLastPathComponent().appendingPathComponent("\(filePath.getFileName()).lrc")
								let data = lyric.data(using: .utf8)
								if fileManager.createFile(atPath: lyricURL.path, contents: data, attributes: nil) {
									print("Lyric for \(title) at \(filePath) is done.")
								} else {
									print("Failed to write lrc file for \(filePath).")
								}
							} else {
								print("Lyric for song \(title) at \(filePath) with ID: \(id) is not found.")
							}
							count += 1
						})
					} else {
						print("Song \(title) at \(filePath) is not found.")
						count += 1
					}
				})
			}
		}
		
		while count != filePaths.count {
			Thread.sleep(forTimeInterval: 1)
		}
		}.run()
} else {
	fatalError()
}
