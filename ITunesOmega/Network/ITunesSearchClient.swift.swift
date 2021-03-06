//
//  ITunesSearchClient.swift.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import Foundation

class ITunesSearchClient {

    private static let baseUrl = URL(string: "https://itunes.apple.com/")!
    private static let defaultSearchParameters = ["media": "music",
                                                  "entity": "album"]
    private static let defaultLookupParameters = ["entity": "song"]

    let session: URLSession
    let decoder = JSONDecoder()
    private var fetchInProgress = false

    init(session: URLSession = URLSession.shared) {
        self.session = session
        decoder.dateDecodingStrategy = .iso8601
    }

    private func url(with parameters: [String: String], path: String) -> URL {
        var components = URLComponents(url: Self.baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        components.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        return components.url!
    }

    private func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<[ITunesEntity], DataResponseError>) -> Void) {
        guard fetchInProgress == false else {return}
        fetchInProgress = true
        session.dataTask(with: urlRequest) { [weak self] data, response, _ in
            self?.fetchInProgress = false
            guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.isSuccessStatusCode,
            let data = data else {
                completion(.failure(DataResponseError.network))
                return
            }
            guard let albumsResponse = try? self?.decoder.decode(ITunesResponse.self, from: data)
            else {
                completion(.failure(DataResponseError.decoding))
                return
            }
            completion(.success(albumsResponse.results))
        }.resume()
    }

    func fetchAlbums(with searchText: String, completion: @escaping (Result<[ITunesEntity], DataResponseError>) -> Void) {
        var parameters = Self.defaultSearchParameters
        parameters["term"] = searchText
        let urlRequest = URLRequest(url: url(with: parameters, path: "search"))
        sendRequest(urlRequest, completion: completion)
    }

    func fetchTracks(with albumId: Int, completion: @escaping (Result<[ITunesEntity], DataResponseError>) -> Void) {
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
