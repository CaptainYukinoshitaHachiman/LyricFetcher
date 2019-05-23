# LyricFetcher

> Fetch all the lyrics using NetEase Music API

## Usage
```shell
$ LyricFetcher --help
Usage:

    $ LyricFetcher

Options:
    --serverPrefix [default: http://localhost:3000] # the listening address of NeteaseCloudMusicApi
    --path [default: working path] # the menu of songs you want to fetch lyrics for
```

## Installation
### Main
```shell
git clone https://github.com/CaptainYukinoshitaHachiman/LyricFetcher.git && cd LyricFetcher
swift build -c release
# macOS
sudo cp ./.build/x86_64-apple-macosx/release/LyricFetcher /usr/local/bin
# Ubuntu
sudo cp ./.build/x86_64-unknown-linux/release/LyricFetcher /usr/local/bin
```
### Dependencies
#### [ExifTool](http://owl.phy.queensu.ca/~phil/exiftool/)
##### macOS
```shell
brew install exiftool
```
##### Ubuntu
```shell
sudo apt install libimage-exiftool-perl
```
#### [NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi)
```shell
git clone https://github.com/Binaryify/NeteaseCloudMusicApi.git
npm install
```

```shell
# run the command below from the same directory before using LyricFetcher
node ./NeteaseCloudMusicApi/app.js
```
