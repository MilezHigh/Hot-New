//
//  YelpDetailsViewModel.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/12/22.
//

import Foundation
import Combine

class YelpDetailsViewModel {
    
    private var subscriptions: Set<AnyCancellable> = []

    var yelpBusinessModel: YelpAPIBusinessModel
    
    @Published var reviews: [YelpAPIReviewModel] = []
    
    init(yelpBusinessModel: YelpAPIBusinessModel) {
        self.yelpBusinessModel = yelpBusinessModel
    }
    
    private func fetchReviews(storeId: String) -> AnyPublisher<[YelpAPIReviewModel], Error> {
        let result = APIService.shared
            .yelpAPIReviews(id: storeId)
            .eraseToAnyPublisher()

        return result
    }
    
    func getReviews(storeId: String) {
        fetchReviews(storeId: storeId)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] models in
                self?.reviews = models
            }
            .store(in: &subscriptions)
    }
}
