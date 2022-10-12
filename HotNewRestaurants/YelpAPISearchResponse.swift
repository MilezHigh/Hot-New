//
//  YelpAPISearchResponse.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/11/22.
//

import Foundation

struct YelpAPISearchResponse: Decodable {
    var businesses: [YelpAPIBusinessModel] = []
}
