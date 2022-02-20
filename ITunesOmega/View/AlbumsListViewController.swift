//
//  AlbumsListViewController.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import UIKit

enum LayoutConstants {
    static let spacer: CGFloat = 30
}

class AlbumsListViewController: UIViewController {

    var viewModel: AlbumsViewModel!

    private let searchField = UITextField()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()

    init(albumsViewModel: AlbumsViewModel) {
        super.init(nibName: nil, bundle: nil)
        viewModel = albumsViewModel
        viewModel.delegate = self
        searchField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Albums search"
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = UIColor.systemBackground

        view.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "search..."
        searchField.borderStyle = .roundedRect
        NSLayoutConstraint.activate(
            [searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                              constant: LayoutConstants.spacer),
             searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                  constant: LayoutConstants.spacer),
             searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -LayoutConstants.spacer)
            ])

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AlbumCell.self, forCellReuseIdentifier: "\(AlbumCell.self)")
        NSLayoutConstraint.activate([tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor,
                                                                    constant: LayoutConstants.spacer),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                       constant: LayoutConstants.spacer)])
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        NSLayoutConstraint.activate([activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }

    func searchPressed() {
        if let searchText = searchField.text, searchText != "" {
            activityIndicator.startAnimating()
            viewModel.searchAlbums(with: searchText)
        }
    }

}

extension AlbumsListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchPressed()
        return true
    }
}

extension AlbumsListViewController: AlbumsListViewModelDelegate {
    func fetchImageComplete(for indexPath: IndexPath) {
        print("Fetch Image complete")
    }

    func fetchAlbumsComplete() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
        }
    }

    func fetchFailed(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }

}

extension AlbumsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(AlbumCell.self)", for: indexPath)
        let album = viewModel.albums[indexPath.row]
        cell.textLabel?.text = album.albumTitle
        return cell
    }

}

extension AlbumsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndex = indexPath.row
        let detailVC = AlbumDetailViewController(viewModel)
        show(detailVC, sender: true)
    }
}
