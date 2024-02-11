////
////  HomeTests.swift
////  SpotifyClone
////
////  Created by Mike Phan on 2/10/24.
////
//
//import XCTest
//@testable import HomeViewModel
//
//class HomeViewModelTests: XCTestCase {
//    
//    var viewModel: HomeViewModel!
//    var mockAPICaller: MockAPICaller!
//    
//    override func setUp() {
//        super.setUp()
//        mockAPICaller = MockAPICaller()
//        viewModel = HomeViewModel(apiCaller: mockAPICaller)
//    }
//    
//    override func tearDown() {
//        viewModel = nil
//        mockAPICaller = nil
//        super.tearDown()
//    }
//    
//    func testFetchData() {
//        // Given
//        let expectation = XCTestExpectation(description: "Fetch data expectation")
//        let mockNewReleases = [Album]() // Populate with mock data
//        let mockFeaturedPlaylists = [Playlist]() // Populate with mock data
//        let mockRecommendedTracks = [AudioTrack]() // Populate with mock data
//        
//        // Configure mock responses
//        mockAPICaller.getNewReleasesCompletion = { completion in
//            completion(.success(mockNewReleases))
//        }
//        mockAPICaller.getFeaturedPlaylistCompletion = { completion in
//            completion(.success(mockFeaturedPlaylists))
//        }
//        mockAPICaller.getRecommendedTracksCompletion = { completion in
//            completion(.success(mockRecommendedTracks))
//        }
//        
//        // When
//        viewModel.fetchData {
//            // Then
//            XCTAssertEqual(self.viewModel.newAlbums, mockNewReleases)
//            XCTAssertEqual(self.viewModel.playlists, mockFeaturedPlaylists)
//            XCTAssertEqual(self.viewModel.tracks, mockRecommendedTracks)
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 5)
//    }
//}
//
//// Mock APICaller class for testing purposes
//class MockAPICaller: APICallerProtocol {
//    var getNewReleasesCompletion: ((Result<[Album], Error>) -> Void)?
//    var getFeaturedPlaylistCompletion: ((Result<[Playlist], Error>) -> Void)?
//    var getRecommendedTracksCompletion: ((Result<[AudioTrack], Error>) -> Void)?
//    
//    func getNewReleases(completion: @escaping (Result<[Album], Error>) -> Void) {
//        getNewReleasesCompletion?(completion)
//    }
//    
//    func getFeaturedPlaylist(completion: @escaping (Result<[Playlist], Error>) -> Void) {
//        getFeaturedPlaylistCompletion?(completion)
//    }
//    
//    func getRecommendedTracks(completion: @escaping (Result<[AudioTrack], Error>) -> Void) {
//        getRecommendedTracksCompletion?(completion)
//    }
//}
