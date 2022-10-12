//
//  APIService.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/11/22.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidResponse(description: String)
    case invalidURL
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse(let description):
            return description
            
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

protocol YelpAPIService {
    func search()
}

class APIService {
    static let shared: APIService = APIService()
        
    private let cache = NSCache<NSString, NSData>()
    
    private let yelpAPIKey: String = "OyFRR5PRd5I5hJ1f1ihFkqyANxelEJi0L6T06z3OvrthiWSan7_0ZZSZ_IhganUVxsCMwcxA-qmCeJJGkcyN-zW5CMWm-IVlyc0JZx2Ya92MU6Smr9OTuHuoy2EzY3Yx"
            
    private init() {}
}

extension APIService {
    private func urlDataPublisher(request: URLRequest, fetchingImageData: Bool = false) -> AnyPublisher<Data, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.global(qos: .background), options: .none)
            .tryMap ({ $0.data })
            .eraseToAnyPublisher()
    }
    
    private func requestObjectPublisher<T: Decodable>(urlRequest: URLRequest) -> AnyPublisher<T, Error> {
        var req = urlRequest
        req.cachePolicy = .useProtocolCachePolicy
        
        return urlDataPublisher(request: req)
            .decode(type: T.self, decoder: JSONDecoder())
            .catch {
                return Fail<T, Error>(error: $0)
            }
            .eraseToAnyPublisher()
    }
    
    /// Image Data Handling
    func loadData(urlString: String, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: urlString) else { return }
        
            if let data = self?.cache.object(forKey: NSString(string: url.absoluteString)) {
                DispatchQueue.main.async {
                    completion(Data(data))
                }
            } else {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    DispatchQueue.main.async { [weak self] in
                        if let data = data {
                            self?.cache.setObject(
                                NSData(data: data),
                                forKey: NSString(string: url.absoluteString)
                            )
                        }
                        completion(data)
                    }
                }
                .resume()
            }
        }
    }
}

extension APIService {
    func yelpAPISearch(attributes: String = "hot_and_new",
                       longitude: Double,
                       latitude: Double) -> AnyPublisher<[YelpAPIBusinessModel], Error> {
        let urlString = "https://api.yelp.com/v3/businesses/search?attributes=\(attributes)&latitude=\(Decimal(latitude))&longitude=\(Decimal(longitude))"
        
        guard let url = URL(string: urlString) else { fatalError("URL assertion failure") }
        
        var urlRequest = URLRequest(url: url)
        let headers = ["Authorization": "Bearer \(yelpAPIKey)"]
        urlRequest.allHTTPHeaderFields = headers
        
        let publisher: AnyPublisher<YelpAPISearchResponse, Error> = requestObjectPublisher(urlRequest: urlRequest)
        let businessPublisher = publisher.map({ $0.businesses }).eraseToAnyPublisher()
        
        return businessPublisher
    }
    
    func yelpAPIReviews(id: String) -> AnyPublisher<[YelpAPIReviewModel], Error> {
        let urlString = "https://api.yelp.com/v3/businesses/\(id)/reviews"
        
        guard let url = URL(string: urlString) else { fatalError("URL assertion failure") }
        
        var urlRequest = URLRequest(url: url)
        let headers = ["Authorization": "Bearer \(yelpAPIKey)"]
        urlRequest.allHTTPHeaderFields = headers
        
        let publisher: AnyPublisher<YelpAPIReviewResponseModel, Error> = requestObjectPublisher(urlRequest: urlRequest)
        let businessPublisher = publisher.map({ $0.reviews }).eraseToAnyPublisher()
        
        return businessPublisher
    }
}
