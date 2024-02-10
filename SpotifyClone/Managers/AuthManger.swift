//
//  AuthManger.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/5/24.
//

import Foundation

struct Constants {
    static let tokenApiUrl = "https://accounts.spotify.com/api/token"
    static let redirectURI = "https://spotify.com"
    static let scopes = "user-read-private user-read-email playlist-modify-public playlist-read-private playlist-read-private user-follow-read user-library-modify user-library-read"
}

final class AuthManger {
    static let shared = AuthManger()
    
    private var refreshingToken: Bool = false
    
    public var signInUrl: URL? {
        guard let client_id = Bundle.main.infoDictionary?["SPOTIFY_CLIENT_ID"] else {
            return nil
        }
        
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(client_id)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
    }

    private init () {}
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    // Spotify uses this for their auth
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    // Spotify expires and will request a new token to auth
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        // Get with 10 minutes left as it expires every hour
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
                
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        // Spotify documentation has good info on this
        
        // Creating API Request
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
        ]

        guard let url = URL(string: Constants.tokenApiUrl) else {
            return
        }
              
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        // Convert to base64
        guard let client_id = Bundle.main.infoDictionary?["SPOTIFY_CLIENT_ID"] else {
            return
        }
        
        guard let client_secret = Bundle.main.infoDictionary?["SPOTIFY_CLIENT_SECRET"] else {
            return
        }
        
        let basicToken = "\(client_id):\(client_secret)"
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }.resume()
        
    }
    
    
    
    
    // Array of escaping closures the blocks, prevents redundent refreshes
    private var onRefreshBlocks = [((String) -> Void)]()
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        // If API call is made in the middle of another call
        
        if shouldRefreshToken {
            // Refresh
            refreshTokenIfNeeded { [weak self] success in
                if let token = self?.accessToken {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshTokenIfNeeded(completion: ((Bool) -> Void)?) {
        guard !refreshingToken else { return }
        
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else { return }
        
        refreshingToken = true
  
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        
        // TODO: This is copied from above. revisit
        guard let url = URL(string: Constants.tokenApiUrl) else {
            return
        }
              
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        // Convert to base64
        guard let client_id = Bundle.main.infoDictionary?["SPOTIFY_CLIENT_ID"] else {
            return
        }
        
        guard let client_secret = Bundle.main.infoDictionary?["SPOTIFY_CLIENT_SECRET"] else {
            return
        }
        
        let basicToken = "\(client_id):\(client_secret)"
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion?(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
        
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            } catch {
                print(error.localizedDescription)
                completion?(false)
            }
        }.resume()
    }

    // Local caching
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
    public func signOut(completion: (Bool) -> Void) {
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        UserDefaults.standard.setValue(nil, forKey: "expirationDate")
        
        completion(true)
    }
}
