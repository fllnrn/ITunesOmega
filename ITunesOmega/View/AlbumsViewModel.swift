//
//  AlbumsListViewModel.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import Foundation
import UIKit

protocol AlbumsListViewModelDelegate: AnyObject {
    func fetchImageComplete(for index: Int)
    func fetchAlbumsComplete()
    func fetchFailed(error: Error)
}

protocol AlbumDetailViewModelDelegate: AnyObject {
    func fetchTracksComplete()
    func fetchTracksFailed(error: Error)
}

class AlbumsViewModel {
    private(set) var albums: [Album] = []
    private var imagesCache: [UIImage?] = []
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

    func albumCover(for index: Int) -> UIImage? {
        if let hasImage = imagesCache[index] {
            return hasImage
        }
        if let url = albums[index].imageURL {
            let albumId = albums[index].albumId
            ImageFetcher.shared.fetchImage(with: url) { [weak self] fetchResult in
                guard let self = self else {return }
                if self.albums.count > index, self.albums[index].albumId == albumId {
                    switch fetchResult {
                    case .success(let image):
                        DispatchQueue.main.async {
                            self.imagesCache[index] = image
                            self.delegate?.fetchImageComplete(for: index)
                        }
                    case .failed:
                        return
                    }
                }
            }
        }
        return nil
    }

    func searchAlbums(with searchText: String) {
        iTunesClient.fetchAlbums(with: searchText) { [weak self] fetchResult in
            guard let self = self else {return}
            switch fetchResult {
            case .success(let entitis):
                let newAlbums = entitis.map({ entity in
                    Album(imageURL: entity.artworkUrl100,
                          albumTitle: entity.collectionName,
                          artistName: entity.artistName,
                          trackCount: entity.trackCount,
                          albumId: entity.collectionId,
                          releaseDate: entity.releaseDate)
                })
                    .sorted(by: { first, second in
                    first.albumTitle < second.albumTitle
                })
                DispatchQueue.main.async {
                    self.albums = newAlbums
                    self.imagesCache = [UIImage?](repeating: nil, count: newAlbums.count)
                    self.delegate?.fetchAlbumsComplete()
                }
                return
            case .failure(let error):
                self.delegate?.fetchFailed(error: error)
                return
            }
        }
    }

    func fetchTracks(for index: Int) {
        guard albums[index].tracks == nil else {
            detailDelegate?.fetchTracksComplete()
            return
        }
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
                        self.detailDelegate?.fetchTracksComplete()
                    }
                }
            case .failure(let error):
                self.detailDelegate?.fetchTracksFailed(error: error)
            }
        }
    }

}
