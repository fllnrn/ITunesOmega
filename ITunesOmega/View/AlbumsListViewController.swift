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
        title = NSLocalizedString("Albums", comment: "Albums")
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = UIColor.systemBackground

        view.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.autocorrectionType = .no
        searchField.placeholder = NSLocalizedString("search...", comment: "search")
        searchField.borderStyle = .roundedRect
        let searchConstraints = [
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LayoutConstants.spacer),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: LayoutConstants.spacer),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -LayoutConstants.spacer)]
        NSLayoutConstraint.activate(searchConstraints)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AlbumCell.self, forCellReuseIdentifier: "\(AlbumCell.self)")
        let tableViewConstraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: LayoutConstants.spacer),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(tableViewConstraints)

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        let activityConstraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        NSLayoutConstraint.activate(activityConstraints)
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
        searchField.resignFirstResponder()
        return true
    }
}

extension AlbumsListViewController: AlbumsListViewModelDelegate {
    func fetchImageComplete(for index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func fetchAlbumsComplete() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
        }
    }

    func fetchFailed(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }
    }

}

extension AlbumsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AlbumCell.self)", for: indexPath)
                as? AlbumCell else {fatalError()}

        let album = viewModel.albums[indexPath.row]
        cell.configure(with: album, cover: viewModel.albumCover(for: indexPath.row))
        return cell
    }

}

extension AlbumsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = AlbumDetailViewController(viewModel)
        viewModel.selectedIndex = indexPath.row
        show(detailVC, sender: true)
    }
}
