//
//  ITunesModel.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import Foundation

struct ITunesResponse: Codable {
    var resultCount: Int
    var results: [ITunesEntity]
}

struct ITunesEntity: Codable {
    let wrapperType: KindOfContent
    let artworkUrl100: String?
    let collectionName: String
    let artistName: String
    let trackCount: Int
    let collectionId: Int
    let releaseDate: Date?
    let trackName: String?
}

enum KindOfContent: String, Codable {
    case track
    case collection
    case artist
}
