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
