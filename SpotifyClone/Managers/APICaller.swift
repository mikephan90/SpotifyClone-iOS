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
        createRequest(with: URL(string: APIConstants.baseApiUrl + "/browse/new-releases?limit=2"), type: .GET) { request in
            
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
            with: URL(string: APIConstants.baseApiUrl + "/browse/featured-playlists?limit=2"), type: .GET
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
    
    public func getRecommendations(genres: Set<String>, completion: @escaping (Result<FeaturedPlaylistResponse, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        
        createRequest(
            with: URL(string: APIConstants.baseApiUrl + "/recommendations?seed_genres=\(seeds)"), type: .GET
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
    
        public func getRecommendGenre(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
            createRequest(
                with: URL(string: APIConstants.baseApiUrl + "/recommendations/available-genre-seeds"), type: .GET
            ) { request in
    
                // TODO: Create a function for the datatask
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
