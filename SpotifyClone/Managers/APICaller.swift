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
    static let shared = APICaller()
    
    private init() {}
    
    // MARK: - Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/albums/" + album.id), type: .GET) { baseRequest in
            URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }.resume()
        }
    }

    // MARK: - Playlists
    
    // MARK: - Profile
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/me"), type: .GET) { baseRequest in
            URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    public func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/browse/new-releases?limit=50"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    public func getFeaturedPlaylist(completion: @escaping (Result<FeaturedPlaylistResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: APIConstants.baseApiUrl + "/browse/featured-playlists?limit=10"), type: .GET
        ) { request in
            
            // TODO: Create a function for the datatask
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping (Result<RecommendationsResponse, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        
        createRequest(
            with: URL(string: APIConstants.baseApiUrl + "/recommendations?limit=10&seed_genres=\(seeds)"), type: .GET
        ) { request in
            
            // TODO: Create a function for the datatask
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    
    public func getRecommendedGenre(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: APIConstants.baseApiUrl + "/recommendations/available-genre-seeds"), type: .GET
        ) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    
    
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
}
