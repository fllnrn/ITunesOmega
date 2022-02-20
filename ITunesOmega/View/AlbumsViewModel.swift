//
//  AlbumsListViewModel.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import Foundation
import UIKit

protocol AlbumsListViewModelDelegate: AnyObject {
    func fetchImageComplete(for indexPath: IndexPath)
    func fetchAlbumsComplete()
    func fetchFailed(error: Error)
}

protocol AlbumDetailViewModelDelegate: AnyObject {
    func fetchTracksComplete()
    func fetchTracksFailed(error: Error)
}

class AlbumsViewModel {
    private(set) var albums: [Album] = [] {
        didSet {
            imagesCache = [UIImage?](repeating: nil, count: albums.count)
        }
    }
    private(set) var imagesCache: [UIImage?] = []
    var selectedIndex: Int? {
        didSet {
            if let selectedIndex = selectedIndex {
                fetchTracks(for: selectedIndex)
            }
        }
    }

    private let iTunesClient = ITunesSearchClient()

    weak var delegate: AlbumsListViewModelDelegate?
    weak var detailDelegate: AlbumDetailViewModelDelegate?

    func searchAlbums(with searchText: String) {
        iTunesClient.fetchAlbums(with: searchText) { [weak self] fetchResult in
            guard let self = self else {return}
            switch fetchResult {
            case .success(let entitis):
                let newAlbums = entitis.map({ entity in
                    Album(imageUIL: entity.artworkUrl100,
                          albumTitle: entity.collectionName,
                          artistName: entity.artistName,
                          trackCount: entity.trackCount,
                          albumId: entity.collectionId)
                }).sorted(by: { first, second in
                    first.albumTitle < second.albumTitle
                })
                DispatchQueue.main.async {
                    self.albums = newAlbums
                }
            case .failed(let error):
                self.delegate?.fetchFailed(error: error)
            }
            self.delegate?.fetchAlbumsComplete()
        }
    }

    func fetchTracks(for index: Int) {
        guard albums[index].tracks == nil else {return}
        let albumId = albums[index].albumId
        iTunesClient.fetchTracks(with: albumId) { [weak self] fetchResult in
            guard let self = self else {return}
            switch fetchResult {
            case .success(let entitis):
                let fetchedTracks = entitis.filter({ entity in
                    entity.wrapperType == KindOfContent.track
                }).map({ entity in
                    Track(trackName: entity.trackName!)
                })
                DispatchQueue.main.async {
                    if self.albums.count > index,
                       self.albums[index].albumId == albumId {
                        self.albums[index].tracks = fetchedTracks
                    }
                }
            case .failed(let error):
                self.detailDelegate?.fetchTracksFailed(error: error)
            }
            self.detailDelegate?.fetchTracksComplete()
        }
    }

}
