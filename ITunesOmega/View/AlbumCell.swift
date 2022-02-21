//
//  AlbumCell.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import UIKit

class AlbumCell: UITableViewCell {
    enum LayoutConstants {
        static let paddingImg: CGFloat = 5
        static let paddingTxt: CGFloat = 20
        static let imageW: CGFloat = 100
        static let imageH: CGFloat = imageW
    }

    let albumImageView = UIImageView()
    let albumTitleLbl = UILabel()
    let artistNameLbl = UILabel()
    let trackCountLbl = UILabel()

    func configure(with album: Album?, cover: UIImage?) {
        if let album = album {
            albumImageView.image = cover ?? UIImage(systemName: "photo")
            albumTitleLbl.text = "\(NSLocalizedString("Album", comment: "Album: name")): \n" + album.albumTitle
            artistNameLbl.text = album.artistName
            trackCountLbl.text = "\(album.trackCount) \(NSLocalizedString("songs", comment: "# songs"))"
        } else {
                albumImageView.image = UIImage(systemName: "photo")
                albumTitleLbl.text = ""
                artistNameLbl.text = ""
                trackCountLbl.text = ""
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        albumTitleLbl.numberOfLines = 2
        albumTitleLbl.font = UIFont.preferredFont(forTextStyle: .headline)
        artistNameLbl.numberOfLines = 2
        let priority = artistNameLbl.contentCompressionResistancePriority(for: .horizontal) + 1
        trackCountLbl.setContentCompressionResistancePriority(priority, for: .horizontal)
        trackCountLbl.font = UIFont.preferredFont(forTextStyle: .footnote)

        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        artistNameLbl.translatesAutoresizingMaskIntoConstraints = false
        trackCountLbl.translatesAutoresizingMaskIntoConstraints = false

        albumImageView.contentMode = .scaleAspectFit

        addSubview(trackCountLbl)
        addSubview(albumImageView)
        addSubview(albumTitleLbl)
        addSubview(artistNameLbl)

        let imageConstraints = [
            albumImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.paddingImg),
            albumImageView.widthAnchor.constraint(equalToConstant: LayoutConstants.imageW),
            albumImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: LayoutConstants.paddingImg),
            albumImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.imageH),
            albumImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutConstants.paddingImg)
        ]
        let titleConstraints = [
            albumTitleLbl.topAnchor.constraint(equalTo: albumImageView.topAnchor),
            albumTitleLbl.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: LayoutConstants.paddingTxt),
            albumTitleLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutConstants.paddingTxt)
        ]
        let nameConstraints = [
            artistNameLbl.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor),
            artistNameLbl.topAnchor.constraint(greaterThanOrEqualTo: albumTitleLbl.bottomAnchor),
            artistNameLbl.leadingAnchor.constraint(equalTo: albumTitleLbl.leadingAnchor),
            artistNameLbl.trailingAnchor.constraint(lessThanOrEqualTo: trackCountLbl.leadingAnchor, constant: -LayoutConstants.paddingTxt)
        ]
        let trackConstraints = [
            trackCountLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutConstants.paddingTxt),
            trackCountLbl.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
            trackCountLbl.bottomAnchor.constraint(equalTo: artistNameLbl.bottomAnchor)
        ]

        NSLayoutConstraint.activate(trackConstraints)
        NSLayoutConstraint.activate(imageConstraints)
        NSLayoutConstraint.activate(titleConstraints)
        NSLayoutConstraint.activate(nameConstraints)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
