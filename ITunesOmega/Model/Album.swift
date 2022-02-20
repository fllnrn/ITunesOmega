//
//  Album.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import Foundation

struct Album {
    let imageUIL: String?
    let albumTitle: String
    let artistName: String
    let trackCount: Int
    let albumId: Int
    var tracks: [Track]?
}

struct Track {
    let trackName: String
}
