//
//  YelpViewModel.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/11/22.
//

import Foundation
import Combine

class YelpViewModel {
    
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var businesses: [YelpAPIBusinessModel] = []
    
    init() {}
    
    private func searchLocalBusinesses(longitude: Double,
                                       latitude: Double) -> AnyPublisher<[YelpAPIBusinessModel], Error> {
        let result = APIService.shared
            .yelpAPISearch(longitude: longitude, latitude: latitude)
            .eraseToAnyPublisher()

        return result
    }
    
    func searchLocalBusinesses(longitude: Double, latitude: Double) {
        searchLocalBusinesses(longitude: longitude, latitude: latitude)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] models in
                self?.businesses = models
            }
            .store(in: &subscriptions)

    }
}
