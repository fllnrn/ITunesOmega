//
//  ITunesSearchClient.swift.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import Foundation

class ITunesSearchClient {

    private static let baseUrl = URL(string: "https://itunes.apple.com/")!
    private static let defaultSearchParameters = ["country": "RU",
                                                  "media": "music",
                                                  "entity": "album"]
    private static let defaultLookupParameters = ["entity": "song"]
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    private func url(with parameters: [String: String], path: String) -> URL {
        var components = URLComponents(url: Self.baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        components.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        return components.url!
    }

    private func sendRequest(_ urlRequest: URLRequest, completion: @escaping (FetchResult) -> Void) {
        session.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.isSuccessStatusCode,
            let data = data else {
                completion(.failed(error: DataResponseError.network))
                return
            }
            guard let albumsResponse = try? JSONDecoder().decode(ITunesResponse.self, from: data)
            else {
                completion(.failed(error: DataResponseError.decoding))
                return
            }
            completion(.success(albums: albumsResponse.results))
        }.resume()
    }

    func fetchAlbums(with searchText: String, completion: @escaping (FetchResult) -> Void) {
        var parameters = Self.defaultSearchParameters
        parameters["term"] = searchText
        let urlRequest = URLRequest(url: url(with: parameters, path: "search"))
        sendRequest(urlRequest, completion: completion)
    }

    func fetchTracks(with albumId: Int, completion: @escaping (FetchResult) -> Void) {
        var parameters = Self.defaultLookupParameters
        parameters["id"] = String(albumId)
        let urlRequest = URLRequest(url: url(with: parameters, path: "lookup"))
        sendRequest(urlRequest, completion: completion)
    }

}

enum DataResponseError: Error {
    case network
    case decoding

    var localizedDescription: String {
        switch self {
        case .network:
            return "Network error"
        case .decoding:
            return "Decoding error"
        }
    }
}

enum FetchResult {
    case success(albums: [ITunesEntity])
    case failed(error: Error)
}
