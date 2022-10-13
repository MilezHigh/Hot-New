//
//  HotNewRestaurantsTests.swift
//  HotNewRestaurantsTests
//
//  Created by Miles Fishman on 10/11/22.
//

import XCTest
import Combine

@testable import HotNewRestaurants

final class HotNewRestaurantsTests: XCTestCase {
    
    private var subscriptions: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testYelpAPIHotAndNew() throws {
        let responseRecieved = expectation(description: #function)
        var responseModels: [YelpAPIBusinessModel] = []
        
        // Testing with mock lat/long of Las Vegas (36.114647, -115.172813)
        
        APIService.shared
            .yelpAPISearch(longitude: -115.172813, latitude: 36.114647)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: {
                responseModels = $0
                responseRecieved.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [responseRecieved], timeout: 6)
        
        XCTAssert(responseModels.count > 1)
    }
}
