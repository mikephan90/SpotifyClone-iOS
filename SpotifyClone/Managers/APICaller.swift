//
//  APICaller.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/5/24.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}

enum HTTPMethod: String {
    case GET
    case POST
}

struct APIConstants {
    static let baseApiUrl = "https://api.spotify.com/v1"
}

final class APICaller {
    
    public typealias ResultCallback<T: Decodable> = (Result<T, Error>) -> Void
    
    static let shared = APICaller()
    
    private init() {}
    
    // MARK: - Categories
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        let url = URL(string: APIConstants.baseApiUrl + "/browse/categories?limit=50")
        createRequest(with: url, type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    public func getCategoryPlaylist(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        let url = URL(string: APIConstants.baseApiUrl + "/browse/categories/\(category.id)/playlists?limit=50")
        createRequest(with: url, type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CategoryPlaylistResponse.self, from: data)
                    let playlists = result.playlists.items
                    completion(.success(playlists))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    // MARK: - Search
    
    public func search(with query: String, completion: @escaping ResultCallback<String>) {
        let type = "album,artist,playlist,track"
        let url = URL(string: APIConstants.baseApiUrl + "/search?limit=10&type=\(type)&q\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        sessionTask(from: url, completion: completion)
    }
    
    // MARK: - Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping ResultCallback<AlbumDetailsResponse>) {
        let url = URL(string: APIConstants.baseApiUrl + "/albums/" + album.id)
        sessionTask(from: url, completion: completion)
    }
    
    // MARK: - Playlists
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping ResultCallback<PlaylistDetailsResponse>) {
        let url = URL(string: APIConstants.baseApiUrl + "/playlists/" + playlist.id)
        sessionTask(from: url, completion: completion)
    }
    
    // MARK: - Profile
    
    public func getCurrentUserProfile(completion: @escaping ResultCallback<UserProfile>){
        let url = URL(string: APIConstants.baseApiUrl + "/me")
        sessionTask(from: url, completion: completion)
    }
    
    // MARK: - Tracks
    
    public func getNewReleases(completion: @escaping ResultCallback<NewReleasesResponse>){
        let url = URL(string: APIConstants.baseApiUrl + "/browse/new-releases?limit=50")
        sessionTask(from: url, completion: completion)
    }
    
    public func getFeaturedPlaylist(completion: @escaping ResultCallback<FeaturedPlaylistResponse>){
        let url = URL(string: APIConstants.baseApiUrl + "/browse/featured-playlists?limit=10")
        sessionTask(from: url, completion: completion)
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping ResultCallback<RecommendationsResponse>) {
        let seeds = genres.joined(separator: ",")
        let url = URL(string: APIConstants.baseApiUrl + "/recommendations?limit=10&seed_genres=\(seeds)")
        sessionTask(from: url, completion: completion)
    }
    
    public func getRecommendedGenres(completion: @escaping ResultCallback<RecommendedGenresResponse>) {
        let url = URL(string: APIConstants.baseApiUrl + "/recommendations/available-genre-seeds")
        sessionTask(from: url, completion: completion)
    }
    
    // MARK: - API Helpers
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        AuthManger.shared.withValidToken { token in
            guard let apiUrl = url else { return }
            
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    public func sessionTask<T: Decodable>(from url: URL?, completion: @escaping ResultCallback<T>) {
        guard let url = url else {
            completion(.failure(APIError.failedToGetData))
            return
        }
        
        createRequest(with: url, type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}


//extension APICaller {
//    private func decodeDebugger(data: Data) {
//        do {
//            let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
//            print(result)
//        } catch DecodingError.keyNotFound(let key, _) {
//            print("Key '\(key.stringValue)' not found.")
//        } catch let error {
//            print("An error occurred: \(error)")
//        }
//    }
//
//    private func printJson(data: Data) {
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            print(json)
//        } catch let error {
//            print("ERROR: \(error)")
//        }
//    }
//}



