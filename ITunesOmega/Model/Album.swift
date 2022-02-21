//
//  Album.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import Foundation

struct Album {
    let imageURL: String?
    let albumTitle: String
    let artistName: String
    let trackCount: Int
    let albumId: Int
    let releaseDate: Date?
    var tracks: [Track]?
}

struct Track {
    let trackName: String
}
