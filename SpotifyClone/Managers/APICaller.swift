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
    case DELETE
    case PUT
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
    
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        let limit = 20
        let url = URL(string: APIConstants.baseApiUrl + "/search?limit=\(limit)&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        createRequest(with: url, type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0) }))
                    searchResults.append(contentsOf: result.albums.items.compactMap({ .album(model: $0) }))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0) }))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0) }))
                    
                    completion(.success(searchResults))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    // MARK: - Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping ResultCallback<AlbumDetailsResponse>) {
        let url = URL(string: APIConstants.baseApiUrl + "/albums/" + album.id)
        sessionTask(from: url, completion: completion)
    }
    
    public func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/me/albums"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
                    completion(.success(result.items.compactMap({ $0.album })))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    public func saveAlbum(album: Album, completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/me/albums?ids=\(album.id)"), type: .PUT) { baseRequest in
            var request = baseRequest
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let code = (response as? HTTPURLResponse)?.statusCode, error == nil else {
                    completion(false)
                    return
                }
                
                print(code)
                completion(code == 200)
                
            }.resume()
        }
    }
    
    // MARK: - Playlists
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping ResultCallback<PlaylistDetailsResponse>) {
        let url = URL(string: APIConstants.baseApiUrl + "/playlists/" + playlist.id)
        sessionTask(from: url, completion: completion)
    }
    
    public func getCurrentUserPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/me/playlists/?limit=50"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: data)
                    completion(.success(result.items))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    public func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) {
        getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                let urlString = APIConstants.baseApiUrl + "/users/\(profile.id)/playlists"
                
                self?.createRequest(with: URL(string: urlString), type: .POST) { baseRequest in
                    var request = baseRequest
                    let json = [
                        "name": name
                    ]
                    
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    
                    URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data, error == nil else {
                            completion(false)
                            return
                        }
                        
                        do {
                            /// Here we do not need to decode anything from the response, only care if we get a response that upon succesful completion
                            let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                            if let response = result as? [String: Any], response["id"] as? String != nil {
                                // TODO: Create an alert to indicate to the user that it was successful
                                completion(true)
                            } else {
                                completion(false)
                            }
                            
                        } catch {
                            completion(false)
                        }
                    }.resume()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func addTrackToPlalist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/playlists/\(playlist.id)/tracks"), type: .POST) { baseRequest in
            var request = baseRequest
            let json = [
                "uris": [
                    "spotify:track:\(track.id)"
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                } catch {
                    completion(false)
                }
            }.resume()
        }
    }
    
    public func removeTrackFromPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/playlists/\(playlist.id)/tracks"), type: .DELETE) { baseRequest in
            var request = baseRequest
            let json = [
                "tracks": [
                    [
                        "uri": "spotify:track:\(track.id)"
                    ]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(result)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                } catch {
                    completion(false)
                }
            }.resume()
        }
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

//
//extension APICaller {
//    private func decodeDebugger<T: Decodable>(data: Data) {
//        do {
//            let result = try JSONDecoder().decode(T.self, from: data)
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
//
//
//
