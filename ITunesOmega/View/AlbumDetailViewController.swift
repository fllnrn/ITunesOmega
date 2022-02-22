//
//  AlbumDetailViewController.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    private let viewModel: AlbumsViewModel

    private let imageView = UIImageView()
    private let albumTitle = UILabel()
    private let artistName = UILabel()
    private let tableView = UITableView()

    init(_ viewModel: AlbumsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        viewModel.detailDelegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        setupUI()
        setupLayout()
        if let selected = viewModel.selectedIndex {
            configure(viewModel.albums[selected], cover: viewModel.albumCover(for: selected))
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        albumTitle.numberOfLines = 0
        artistName.numberOfLines = 0
        imageView.contentMode = .topRight

    }

    private func setupLayout() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageConstraints = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LayoutConstants.spacer),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LayoutConstants.spacer),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(imageConstraints)

        view.addSubview(albumTitle)
        albumTitle.translatesAutoresizingMaskIntoConstraints = false
        let titleConstraints = [
            albumTitle.topAnchor.constraint(equalTo: imageView.topAnchor),
            albumTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: LayoutConstants.spacer),
            albumTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -LayoutConstants.spacer)
        ]
        NSLayoutConstraint.activate(titleConstraints)

        view.addSubview(artistName)
        artistName.translatesAutoresizingMaskIntoConstraints = false
        let bandCondtraints = [
            artistName.topAnchor.constraint(equalTo: albumTitle.bottomAnchor, constant: LayoutConstants.spacer),
            artistName.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: LayoutConstants.spacer),
            artistName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -LayoutConstants.spacer)
        ]
        NSLayoutConstraint.activate(bandCondtraints)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let topToImage = tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LayoutConstants.spacer)
        topToImage.priority -= 1
        let tableConstraints = [
            topToImage,
            tableView.topAnchor.constraint(greaterThanOrEqualTo: artistName.bottomAnchor, constant: LayoutConstants.spacer),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(tableConstraints)

    }

    func configure(_ album: Album, cover: UIImage?) {
        imageView.image = cover
        if let year = album.releaseDate?.year {
            albumTitle.text = "\(year) - \(album.albumTitle)"
        } else {
            albumTitle.text = "\(album.albumTitle)"
        }
        artistName.text = album.artistName
    }
}

extension AlbumDetailViewController: AlbumDetailViewModelDelegate {
    func fetchTracksComplete() {
        tableView.reloadData()
    }

    func fetchTracksFailed(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }

}

extension AlbumDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selected = viewModel.selectedIndex {
            return viewModel.albums[selected].tracks?.count ?? 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        if let selected = viewModel.selectedIndex,
           let tracks = viewModel.albums[selected].tracks {
            cell.textLabel?.text = tracks[indexPath.row].trackName
        }
        return cell
    }

}
