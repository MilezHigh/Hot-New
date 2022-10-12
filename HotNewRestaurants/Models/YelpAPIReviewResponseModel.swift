//
//  YelpAPIReviewResponseModel.swift
//  HotNewRestaurants
//
//  Created by Miles Fishman on 10/12/22.
//

import Foundation

struct YelpAPIReviewResponseModel: Decodable {
    var reviews: [YelpAPIReviewModel]
}
