//
//  AlbumDetailViewController.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    private let viewModel: AlbumsViewModel

    init(_ viewModel: AlbumsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.detailDelegate = self
    }

}

extension AlbumDetailViewController: AlbumDetailViewModelDelegate {
    func fetchTracksComplete() {
        print("show tacks on view")
    }

    func fetchTracksFailed(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }

}
